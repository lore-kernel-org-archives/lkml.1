Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXCTLma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXCTLma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXCTLm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:42:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40776 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbXCTLm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:42:29 -0400
Date: Tue, 20 Mar 2007 12:43:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-ID: <20070320114307.GA10240@uranus.ravnborg.org>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net> <45FD8684.4030501@googlemail.com> <20070319162529.7724b150.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319162529.7724b150.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 04:25:29PM -0700, Andrew Morton wrote:
> On Sun, 18 Mar 2007 19:35:48 +0100
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > WARNING: could not find versions for .tmp_versions/built-in.mod
> > WARNING: could not find versions for .tmp_versions/built-in.mod
> > WARNING: could not find versions for .tmp_versions/built-in.mod
> > WARNING: could not find versions for .tmp_versions/built-in.mod
> > WARNING: could not find versions for .tmp_versions/built-in.mod
> > WARNING: could not find versions for .tmp_versions/built-in.mod
> 
> This is caused by git-kbuild.  I don't know what the significance of it is.

This is caused by the patch that runs modpost on all files
used to make up vmlinux.
The warning is harmless and I will try to fix it up tonight or tomorrow.

	Sam
