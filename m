Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZDUVAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZDUVAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZDUU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:59:58 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:49221 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZDUU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CWEvx8aGCrf8i4B7uUyhDuh9aMqunWKMmVbTo+DmpdWzgYdlG6umcxjQJRfHSXiwIm
         HUSsd3iL7srSnydHK3kfx5RfU3zHTBBv/lMwlL54YDfrVEre8UKmt5bpRvBAhozHIKFT
         D7/WjK5UIeoURAb8H04dtLGrOl1BZh47leARo=
Date: Tue, 21 Apr 2009 22:59:50 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, schwab@linux-m68k.org, krzysztof.h1@poczta.fm
Subject: Re: [stable] [BISECTED] x11 fbdev on intelfb hangs hard after
	66c1ca019078220dc1bf968f2bb18421100ef147
Message-ID: <20090421205949.GB5573@linux>
References: <1239314524.7390.14.camel@mj> <20090410081428.GA5595@linux> <20090421183424.GE22386@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421183424.GE22386@hera.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:34:24PM +0000, Chris Wright wrote:
> * Andrea Righi (righi.andrea@gmail.com) wrote:
> > Thanks for reporting Pavel. I agree to revert 66c1ca ASAP.
> 
> Rather than dropping from -stable queue, looks like we should be adding:
> 513adb58685615b0b1d47a3f0d40f5352beff189 "fbdev: fix info->lock deadlock
> in fbcon_event_notify()"? 
> 
> thanks,
> -chris

Correct.

Both Andreas and Krzysztof (in cc) tested this and reported that it
fixes the issue (see also http://patchwork.kernel.org/patch/17753/).

Thanks,
-Andrea
