Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYGFPM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYGFPM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYGFPMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:12:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:55645 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbYGFPMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DUWLD4T8fot24xvc8AKoef3rp7VX2ySU+5dJ9JWRVC2kKcVWNEuQfTzjmD+07DdwKO
         lNqmatfAcklMAe2hrJyIQzI7Sl7hMNiYqV37U/DB574WXkgvNaIwhAgtdoMazO/yrGKb
         tz8EVJd3ljCimK5bsMTdntuAUpv7mK/qzMl2s=
Date: Sun, 6 Jul 2008 17:12:20 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706151215.GB5401@joi>
References: <20080705131924.GA2083@joi> <20080705235148.GW28946@ZenIV.linux.org.uk> <20080706001148.GX28946@ZenIV.linux.org.uk> <20080706040519.GZ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706040519.GZ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 05:05:19AM +0100, Al Viro wrote:
> 	c) *HOWEVER*, all races aside, we have a genuinely fscked up
> API.  Each of these parport scheduling entities has a parameter - timeslice.
> That parameter is exposed as sysctl.  And we definitely want these per-open,
> not per-port.  And we get everything for the same port mapped to the same
> sysctl.

Why we want it per-open? What's a timeslice (in this context)?
