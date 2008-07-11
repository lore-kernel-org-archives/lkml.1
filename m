Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYGKPoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYGKPoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYGKPn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:43:59 -0400
Received: from mail.mba-software.de ([62.75.137.201]:58887 "EHLO
	mail.mba-software.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYGKPn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:43:59 -0400
Message-ID: <48777FB9.8090102@mba-software.de>
Date: Fri, 11 Jul 2008 17:43:53 +0200
From: =?ISO-8859-1?Q?Marian_Aldenh=F6vel?= 
	<marian.aldenhoevel@mba-software.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Gilles Espinasse <g.esp@free.fr>
Subject: Re: Building a kernel for SiS55-based system. No, wait! It's a  Vortex86SX.
References: <4860959E.6020207@mba-software.de> <1214471767.48635e574384b@imp.free.fr> <48708724.6020904@mba-software.de> <25e301c8df53$6a525780$f9b5a8c0@pii350>
In-Reply-To: <25e301c8df53$6a525780$f9b5a8c0@pii350>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>> Could you try with distrib images to know if it could be related to your
>>> compilation system

Thank you for your advice re network boot and trying stock kernels. I did
set that up and learned a lot.

For one I learned that the CPU I am fighting with is in fact called
Vortex86SX. My first information (see subject) was either wrong or is a
less well-known alias for the same chip. Sorry for that.

Once armed with that information I was able to find more bits and pieces:

   http://www.phys.ethz.ch/~abe/MicroClientJr/

 > "Kompatibel zu 486SX statt Pentium MMX: Kleinerer Befehlssatz, keine FPU,
 > schmälere Bus-Breite. Debian GNU/Linux 4.0 Etch läuft darauf (X.org aus Etch
 > nicht), grml und Ubuntu nicht. Debian GNU/Linux Lenny/Sid Userland läft
 > ebenfalls darauf, aber der 2.6.24er Kernel aus Sid nicht."

"Compatible with 486SX instead of Pentium MMX: Smaller Instruction set, no
FPU, narrower Bus. Debian GNU/Linux 4.0 Etch are running (X.org from Etch
does not), grml and Ubuntu are not. Debian GNU/Linux Lenny/Sid Userland
works but the 2.6.24 Kernel from Sid does not."

The builder of the chip even has detailed information on how to build
Linux 2.6.18 for it:

   ftp://download@ftp.dmp.com.tw/vortex86sx/Vortex86SX_Linux_HowTo.pdf

Patches included:

   http://www.dmp.com.tw/tech/Vortex86SX/patch-2.6.18-DMP.gz

The bottom line is that current kernels don't work, the last one I know that
works is 2.6.18.. That is used in Debian Etch and I was able to confirm
operation by booting that one.

I have since downgraded my build-system to use 2.6.18.3 and that runs
fine on my hardware. So now I can set it all up any way I like directly
from upstream sources. Hooray!

Thank you very much.

Maybe someone smarter than me can figure out what the actual problem is,
when it was introduced since 2.6.18 and then presumeably fix it. Until
then I think I can live OK with the kernel I have now.

Ciao, MM
-- 
Marian Aldenhövel, Rosenhain 23, 53123 Bonn
http://www.marian-aldenhoevel.de
"I ran some quick calculations on it. He's about 80% on the right
  track.  That leaves him only 20% dead when he crashes." Bob C


