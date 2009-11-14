Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZKNFms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZKNFms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZKNFmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:42:47 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:51100 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZKNFmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dtvbqLQIPLZJynHFAlAlsedfVzNr+hWxNkyZiKCAa6ZrWBdW+57FJTL5qPOlL52ACO
         Zmlup1Lizwualvm1HtlXio5DcvkjgLhqzi1HR96O3htgQa35Gmxd3CZTnvAj8hX5X+MK
         ITq7ok7C/MHH8Vl2F7orSnJhrRyFIT9e8ColQ=
Date: Fri, 13 Nov 2009 21:42:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, olh@suse.de,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mouse button 1 emulation for mac_hid
Message-ID: <20091114054246.GF4463@core.coreip.homeip.net>
References: <1257762531.7245.23.camel@no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257762531.7245.23.camel@no>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

On Mon, Nov 09, 2009 at 11:28:51AM +0100, Soeren Sonnenburg wrote:
> (this is a resent with all the people included in the CC that git
>          blame'd they are the authors).
> 
> Dear all,
> 
> I am not sure what the future of mac_hid is (the source says will be
> removed, but since 9 years). In case it stays in kernel the attached
> patch adds support for mouse button 1 emulation. If this driver stays in
> the kernel I would also suggest to rename it - it is not mac specific (I
> am using this on a netbook).
> 
> Rationale? Broken touchpads, within linux unsupported (multi-)touchpads
> where click and hold + moving the mouse does not work (yet?).
> 

I would rather fix the touchpads so they work properly than pile more
quirks in kernel.

Thanks.

-- 
Dmitry
