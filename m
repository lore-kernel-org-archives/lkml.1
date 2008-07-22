Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYGVRLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYGVRLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYGVRK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:10:56 -0400
Received: from animx.eu.org ([216.98.75.249]:52256 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYGVRK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:10:56 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 13:10:55 EDT
Date: Tue, 22 Jul 2008 12:40:39 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Floppy access by dd fails for 2.6.26-rc2 to final, possibly even earlier
Message-ID: <20080722164039.GA18079@animx.eu.org>
Mail-Followup-To: Gene Heskett <gene.heskett@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807220841.27796.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807220841.27796.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> I just been advised by private email that I an not the only one who has lost the 
> use of his floppy drive via dd.  The corresponder noted that he had a copy of 
> DSL with a 2.4.something kernel, and his drive worked flawlessly while booted 
> to DSL.
> 
> So now there are at least 2 floppy users wandering in the wilderness looking for 
> water.  We need it to support 20 year old computers without a TCP stack or 
> network cards.

I guess I'll chime in.  I'm not sure this is the same problem or not, but my
Alpha AS1000a (EV56 5/400) has never successfully been able to read the
floppy.  I always get garbage.  The drive does work as I can use the RCU
from floppy from the Arc BIOS.

Linux sees this device as a 2.88mb floppy.  It is a 1.44mb and the
information in the Arc BIOS is set to 1.44mb (I don't think it matters, I
boot from SRM, not sure how to set the floppy there)

I also do not see any errors or other useful messages in the logs.

Jun  1 15:23:06 narf kernel: [4262383.309846] Floppy drive(s): fd0 is 2.88M
Jun  1 15:23:06 narf kernel: [4262383.324494] FDC 0 is a National Semiconductor PC87306

I tried forcing to use a specific type:
Jun  1 16:21:38 narf kernel: [4194206.301784] floppy0: setting CMOS code to 4
Jun  1 16:21:38 narf kernel: [4194206.301784] Floppy drive(s): fd0 is 1.44M
Jun  1 16:21:38 narf kernel: [4194206.314479] FDC 0 is a National Semiconductor PC87306

But that failed even worse with errors on sector 0.  (NOTE the floppy was
good)

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
