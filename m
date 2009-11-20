Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZKTRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZKTRvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZKTRvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:51:19 -0500
Received: from 70-90-202-97-Albuquerque.hfc.comcastbusiness.net ([70.90.202.97]:55221
	"EHLO deneb.dwf.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZKTRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:51:18 -0500
Message-Id: <200911201751.nAKHpLpk012212@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3
To: linux-kernel@vger.kernel.org
Subject: Re: Problems building 2.6.31.6 with 64bit Fedora-11
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 20 Nov 2009 10:51:21 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent this message to the list yesterday, but it never appeared,
Probably a side effect of my new Fedora-11 install.  In any case
here is another try. The question is about a failue of a build
of linux 2.6.31.6 on a 64bit Pentium 4.

---

> What arch are you building on?

a 64bit Pentium 4.
> 
> What does 'file' say about the bad object files?
>

A File shows:

reg@deneb kernel]$ file *.o
microcode.o:       ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not 
stripped
microcode_amd.o:   ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not 
stripped
microcode_core.o:  ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not 
stripped
microcode_intel.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not 
stripped
test_nx.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not 
stripped

while nm shows

[reg@deneb kernel]$ nm *.o
nm: microcode.o: File format not recognized
nm: microcode_amd.o: File format not recognized
nm: microcode_core.o: File format not recognized
nm: microcode_intel.o: File format not recognized
nm: test_nx.o: File format not recognized

Almost looks like the wrong version of nm, but Im sure someone
out there will have a better idea.


-- 
                                        Reg.Clemens
                                        reg@dwf.com


