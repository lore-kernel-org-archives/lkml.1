Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZIMW4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZIMW4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZIMW4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZIMW4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:56:49 -0400
Subject: Re: [PATCH 1/3] Creds: creds->security can be NULL is selinux is
 disabled
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, sds@tycho.nsa.gov,
       mingo@elte.hu, dhowells@redhat.com
In-Reply-To: <alpine.LRH.2.00.0909140823320.27953@tundra.namei.org>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
	 <alpine.LRH.2.00.0909140823320.27953@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Sep 2009 18:55:41 -0400
Message-Id: <1252882541.16335.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 08:23 +1000, James Morris wrote:
> On Sat, 12 Sep 2009, Eric Paris wrote:
> 
> > __validate_process_creds should check if selinux is actually enabled before
> > running tests on the selinux portion of the credentials struct.
> 
> Have you verified that this fixes the problem?

Yes, I was able to reproduce the problem using selinux=0 at the command
line.  This patch fixes the problem.

-Eric

