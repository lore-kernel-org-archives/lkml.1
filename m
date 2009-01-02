Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbZABTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbZABTLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZABTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:11:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500AbZABTLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:11:11 -0500
Date: Fri, 2 Jan 2009 20:09:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090102190902.GA25969@redhat.com>
References: <20081229041352.6bbdf57c@tpl> <20090102184232.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102184232.GH28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02, Al Viro wrote:
>
> Bloating with mutex is over the top, indeed, but why can't we simply keep
> a pointer to fasync_struct in there?  Do we ever have a struct file with
> several fasync_struct?

pipe_rdwr_fasync() ?

Oleg.

