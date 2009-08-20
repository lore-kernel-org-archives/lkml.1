Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZHTOE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZHTOE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZHTOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbZHTOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:04:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090820154734.3db7d7ae@leela>
References: <20090820154734.3db7d7ae@leela> <20090819163616.3716.18477.stgit@localhost.localdomain> <17328.1250762526@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] bsdacct: switch credentials for writing to the accounting file
Date: Thu, 20 Aug 2009 15:04:03 +0100
Message-ID: <3961.1250777043@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt <mschmidt@redhat.com> wrote:

> When process accounting is enabled, every exiting process writes a log
> to the account file. In addition, every once in a while one of the
> exiting processes checks whether there's enough free space for the log.
> 
> SELinux policy may or may not allow the exiting process to stat the fs.
> So unsuspecting processes start generating AVC denials just because
> someone enabled process accounting.
> 
> For these filesystem operations, the exiting process's credentials
> should be temporarily switched to that of the process which enabled
> accounting, because it's really that process who wanted to have the
> accounting information logged.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
