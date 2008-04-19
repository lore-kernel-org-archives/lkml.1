Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYDSBwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYDSBwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYDSBwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:52:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:38697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYDSBwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:52:33 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Matthew <jackdachef@gmail.com>, linux-acpi@vger.kernel.org
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Date: Fri, 18 Apr 2008 21:51:48 -0400
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
In-Reply-To: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804182151.49021.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2008, Matthew wrote:
> Hi everyone, hi Linus,
> 
> congratulations on this new great kernel-release :)
> 
> I've another "regression" to report for 2.6.25:
> 
> it's concerning much higher temperatures being read out by the
> "coretemp" kernel-module in comparison to 2.6.24* series
> 
> e.g. where temperatures were around 40-47°C they are now constantly
> jumping around 55-70°C (even in idle !)
> 
> several other users/testers have reported this issue too (both on
> zen-sources [heavy patched] & latest gentoo-sources) [slightly
> patched]:
> 
> http://forums.gentoo.org/viewtopic-t-684812-highlight-.html
> 
> if I understood git right it (also) happens in conjunction with an 3
> weeks old acpi-snapshot
> (http://repo.or.cz/w/linux-2.6/zen-sources.git?a=heads) integrated in
> zen-sources
> 
> I can "reproduce" this on an Intel Core 2 Duo 6600 (Conroe) with a P5W
> DH Deluxe mainboard (by Asus) since at least 2.6.25-rc8 (or possibly
> also rc7)
> 
> the temperatures on mobile core (2) duo intel processors [e.g. an
> T7500] seem to be read out correctly - I can't tell it exactly but
> this seems to be an entirely "cosmetical" issue
> (hopefully it's not the opposite and the values are now read out
> correctly since such high temps would be very worrying ;) )
> 
> Keep up the great work & please don't forget your growing amount of
> linux-desktop users :)
> 
> Regards
> 
> Mat

Hello Mat,
I'm not familiar with "coretemp", can you point me to the exact version
of the application you are running so I can see how it is getting at
the underlying information?

Also, do you see any change with and without kernel built with CONFIG_THERMAL=y?

thanks,
-Len
