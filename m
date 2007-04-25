Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXDYDif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXDYDif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 23:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161554AbXDYDif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 23:38:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48291 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXDYDie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 23:38:34 -0400
Date: Tue, 24 Apr 2007 20:39:07 -0700
From: Greg KH <greg@kroah.com>
To: ray-gmail@madrabbit.org
Cc: Adrian Bunk <bunk@stusta.de>, Wolfgang Erig <Wolfgang.Erig@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: regression with gammu on 2.6.21-rc7
Message-ID: <20070425033907.GA10322@kroah.com>
References: <20070420085853.GA5594@erig.dyndns.org> <20070423054717.GB17997@kroah.com> <20070423081022.GA25694@erig.dyndns.org> <20070425001356.GB1183@kroah.com> <2c0942db0704241812m72e02611sc41f83c1b89629be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0704241812m72e02611sc41f83c1b89629be@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 06:12:33PM -0700, Ray Lee wrote:
>  On 4/24/07, Greg KH <greg@kroah.com> wrote:
> > Also, if you know how to use git, doing a 'git bisect' to try to track
> > down the problem commit would be very helpful.
> 
>  Has to do with SIGIO, see this blog post:
> 
>  http://blog.cihar.com/archives/2007/04/24/kernel_2_6_21_hits_gammu/

Ah, thank you very much, that makes more sense as nothing changed in
that usb-serial driver and I was starting to get a bit worried...

thanks,

greg k-h
