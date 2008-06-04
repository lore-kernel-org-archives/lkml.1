Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbYFDXbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbYFDXbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbYFDXbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:31:43 -0400
Received: from n54.bullet.mail.sp1.yahoo.com ([98.136.44.32]:46283 "HELO
	n54.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754286AbYFDXbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:31:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 203539.95784.bm@omp106.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=v3vG1ml3AEsGb1h82/4UtX8MtQiM8ZgMbzsSZux6h6CKQ0ruKYl9rHOsL7cfEU/6pqMz8Kdjm2z9ASv4BsB9VjvKzEH/UiKIPYCAbKq6aG6eTYq2XMPu6TBPb82xh4GNr6J5WbFfOAbYMMuCZhZ7CE63Cs5tt7BELcRYbhEZIFg=;
X-Mailer: YahooMailWebService/0.7.199
Date: Wed, 4 Jun 2008 16:31:39 -0700 (PDT)
From: Stan Cunningham <stan.cunningham@yahoo.com>
Reply-To: stan.cunningham@yahoo.com
Subject: Re: ASUS SplashTop and Phoenix Hyperspace infringing kernel copyright and GPL
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, legal@narasimha.gpl-violations.org,
       license-violation@gnu.org
In-Reply-To: <483205C8.8050108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <98404.93587.qm@web57413.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

--- On Mon, 5/19/08, Chris Snook <csnook@redhat.com> wrote:
> Out of curiosity, have you tried asking them nicely?  ASUS
> seems to be pretty 
> responsive when oversights like this are pointed out to
> them.  Of course, if you 
> start with a lawsuit threat you're inclined to hit the
> slow path (legal) rather 
> than the fast path (support/community relations).  I have
> no idea how responsive 
> Phoenix is to issues like this, but a friendly request goes
> over much better 
> than a shot across the bow.

I haven't heard anything from ASUS, but an employee from DeviceVM, the company that develops SplashTop, responded here: http://lists.gpl-violations.org/pipermail/legal/attachments/20080521/f74f7e2d/ASUSSplashTopandPhoenixHyperspaceinfringingkernelcopyrightandGPL-0001.mht

There are several unresolved issues: first of all, it is ASUS and not DeviceVM that is distributing the binary to customers who buy motherboards and laptops. It is therefore ASUS' obligation to provide the the "complete machine-readable" source code to those customers. I've included the relevant section of the GPLv2 below. You'll notice that the GPLv2 sets out three possible ways to provide source code, detailed in sections 3a, 3b and 3c. ASUS _cannot_ hide behind section 3c by simply pointing customers to SplashTop/DeviceVM's website because neither ASUS nor DeviceVM are noncommercial, and in fact, they are _selling_ motherboards and laptops containing GPLv2 software. 

------------------------
3. You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:

    a) Accompany it with the complete corresponding machine-readable
    source code, which must be distributed under the terms of Sections
    1 and 2 above on a medium customarily used for software
    interchange; or,

    b) Accompany it with a written offer, valid for at least three
    years, to give any third party, for a charge no more than your
    cost of physically performing source distribution, a complete
    machine-readable copy of the corresponding source code, to be
    distributed under the terms of Sections 1 and 2 above on a medium
    customarily used for software interchange; or,

    c) Accompany it with the information you received as to the offer
    to distribute corresponding source code.  (This alternative is
    allowed only for noncommercial distribution and only if you
    received the program in object code or executable form with such
    an offer, in accord with Subsection b above.)
------------------------

So ASUS must either satisfy either 3a or 3b. To satisfy 3a, ASUS must package the complete Linux source code and any other GPL-ed code with every SplashTop-containing motherboard and laptop. To satisfy 3b, they must place a written offer to provide the  "complete machine-readable" source code to the .

One thing I want to ask everybody out there who has bought a Splashtop-containing motherboard or laptop: did it come with the source code (thus fulfilling section 3a) or with a written offer in the package (thus fulfilling section 3b)? If not, then ASUS is definitely violating the GPLv2.

Secondly: if ASUS is simply distributing DeviceVM's patches to the Linux kernel, ASUS is still violating the GPLv2 because patches by definition are _not complete_ and they leave out the main bulk of the kernel code. DeviceVM admits (http://www.splashtop.com/blog/index.php/2008/05/20/reminder-source-code-and-how-to-get-it/) that the "Source Code" they provide is only ~12MB, which is blatantly insuffcient considering that the code for a linux-2.6 kernel is at least 41 MB.

You may think patches are OK because the mainline kernel to which they are applied is mirrored elsewhere: this is still a violation because the GPLv2 requires _complete_ source code, no ifs ands or buts. The GPLv2 never even mentions patches.

Now I have a theory as to why ASUS/DeviceVM are posting patches instead of the full kernel: it makes it harder for copyright holders to find out that a driver or modification is missing from the patchset. ASUS can claim that the differences in behavior between a patched mainline kernel and the binary blob burnt onto the BIOS flash chip are due to the patch not being applied to the correct version of the mainline kernel. Plus, if they are caught, they don't look as bad saying "Oops, we forgot a patch within the patchset. Sorry."

However, if ASUS were to provide the complete yet incorrect source code, and compiling it yielded a kernel with a different behavior from the binary kernel that is burnt onto the BIOS flash chip, then it would be immediately obvious that they are intentionally leaving out modifications from the source code.

I also think that ASUS is using DeviceVM a front-man with which to skirt the law, and if worse comes to worse ASUS will try to blame DeviceVM for infringing on the GPL. But it's not going to work because ASUS is a commercial entity, selling GPL-ed software on commercial products, and is itself responsible for distributing the code as specified by sections 3a and 3b of the GPLv2.

Finally, I'd like to bring your attention to an article (http://community.zdnet.co.uk/blog/0,1000000567,10008346o-2000331761b,00.htm) in which DeviceVM states that " the part of Splashtop that is embedded into BIOS and achieves the instant-on first screen is based on a proprietary RTOS that DeviceVM developed." This sounds less of a bootloader and more like a Virtual Machine because it apparently brings up Linux from a frozen state without booting it. In any case, I urge someone with the hardware and know-how to check if this "proprietary RTOS" uses any EXPORT_SYMBOL_GPL.

Thanks,
Stan


      

