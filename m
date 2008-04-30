Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbYD3XsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbYD3XsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYD3XsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:48:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbYD3XsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:48:04 -0400
Message-ID: <4819050C.9060800@zytor.com>
Date: Wed, 30 Apr 2008 16:47:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oliver Hartkopp <oliver@hartkopp.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net>
In-Reply-To: <4818F093.3070105@hartkopp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Hartkopp wrote:
> Hi all,
> 
> i wonder about the Kernel naming convention in the merge phase before
> the -rc1 is officially tagged by Linus.
> 
> Won't it be more precisely to name the current snapshot
> 2.6.26-merge-git16 instead of 2.6.25-git16?
> 
> It is not that i would suggest to have a new git tag in this merge phase 
> but only the Makefile should be changed at the beginning of this phase 
> to identify the ongoing work for the 2.6.26:
> 
> ------
> diff --git a/Makefile b/Makefile
> index d3634cd..b8c85a4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,8 +1,8 @@
> VERSION = 2
> PATCHLEVEL = 6
> -SUBLEVEL = 25
> -EXTRAVERSION =
> -NAME = Funky Weasel is Jiggy wit it
> +SUBLEVEL = 26
> +EXTRAVERSION = -merge
> +NAME = unnamed
> 
> # *DOCUMENTATION*
> # To see a list of typical targets execute "make help"
> ------
> 
> Introducing the new '-merge' version _that_ early helps to avoid the 
> version confusion in /lib/modules and also allows people to work with 
> kernel version depended stuff in a very early phase.
> 

And it'll break all the robotic stuff again.

Foo-gitX has always been a development snapshot which *follows* Foo.

	-hpa
