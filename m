Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXFOSXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXFOSXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXFOSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:22:54 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16186 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXFOSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:22:53 -0400
X-IronPort-AV: i="4.16,425,1175486400"; 
   d="scan'208"; a="32538825:sNHT29696639"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 14:25:41 -0400
User-Agent: KMail/1.9.5
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706141014.21574.rgetz@blackfin.uclinux.org> <or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151425.41975.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 15 Jun 2007 18:22:51.0437 (UTC) FILETIME=[2F18BDD0:01C7AF7A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14 Jun 2007 13:46, Alexandre Oliva pondered:
> On Jun 14, 2007, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > As a person pretty familiar with the hardware in these types of
> > devices - this just isn't practical.
> 
> Well, then, ok: do all that loader and hardware signature-checking
> dancing, sign the image, store it in the machine, and throw the
> signing key away.  This should be good for the highly-regulated areas
> you're talking about.  And then, since you can no longer modify the
> program, you don't have to let the user do that any more.  Problem
> solved.

I don't think so - the GPL3 doesn't state that you must convey the same rights 
to end users that you have, it says you must provide installation 
information, including your keys, or you can not ship the product.

That is the way I read the following sections (let me know if I mis-read 
anything):

======================
"Installation Information" for a User Product means any methods, procedures, 
authorization keys, or other information required to install and execute 
modified versions of a covered work in that User Product from a modified 
version of its Corresponding Source. 

The information must suffice to ensure that the continued functioning of the 
modified object code is in no case prevented or interfered with solely 
because modification has been made.

If conditions are imposed on you (whether by court order, agreement or 
otherwise) that contradict the conditions of this License, they do not excuse 
you from the conditions of this License. 

If you cannot convey the Program, or other covered work, so as to satisfy 
simultaneously your obligations under this License and any other pertinent 
obligations, then as a consequence you may not convey it at all.

===================

I read "are imposed on you (or otherwise)" to mean "by you" as well. If so, 
you throwing away the private keys are not an option.

I need to think a bit more of Rob's opinion of ROM's are illegal - but 
providing the installation information of "send $1M NRE and object code to 
xxx ROM vendor, and wait 16 weeks for 500k units, take one to a board shop, 
pay $1k for them to re-work your BGA - if the xray says it is screwed up, you 
have 499,999 other units to try." - may meet the language, but doesn't meet 
the spirit of the GPL either...

-Robin
