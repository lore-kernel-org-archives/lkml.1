Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbXLFPzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbXLFPzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXLFPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:55:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbXLFPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:55:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1196954713-5545-1-git-send-email-crquan@gmail.com>
References: <1196954713-5545-1-git-send-email-crquan@gmail.com>
To: Denis Cheng <crquan@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] fs/afs/cell.c: use LIST_HEAD instead of LIST_HEAD_INIT
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 06 Dec 2007 15:55:29 +0000
Message-ID: <13649.1196956529@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng <crquan@gmail.com> wrote:

> single list_head variable initialized with LIST_HEAD_INIT could almost
> always can be replaced with LIST_HEAD declaration, this shrinks the code
> and looks better.

And mucks up TAGS generation:-/
