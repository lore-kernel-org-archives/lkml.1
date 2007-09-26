Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbXIZLDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbXIZLDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXIZLDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:03:09 -0400
Received: from web51411.mail.re2.yahoo.com ([206.190.39.152]:27014 "HELO
	web51411.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753861AbXIZLDI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:03:08 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 07:03:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=DNwIO0KpHOQJaF68+FDh/Ejzha/wwz511cuTdOMNvha300yHdUMYqOFXM19zjKwtXBOomWm2H4FiyzLKzz1eZQZo+Ka+Qjl4lSR/rEhAt2+9cu9OztVAmCswSVordkcTD+l9ZbuNVR8IU9xKXkvCuYMFIhBa9U8pTDoOWKmiwvA=;
X-YMail-OSG: Zzid_L0VM1nKiutIWCdzzyVBRqxdFJTZ9lSinPt8vzuITa_hDrseBXxQF0k6euIJSg--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Wed, 26 Sep 2007 03:56:26 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on AMD Geode LX800
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <637040.99806.qm@web51411.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
this is what git bisect told me about the problem:

jpo@jpo-laptop:~/linux-2.6$ git bisect good
4fd06960f120e02e9abc802a09f9511c400042a5 is first bad commit
commit 4fd06960f120e02e9abc802a09f9511c400042a5
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Jul 11 12:18:56 2007 -0700

    Use the new x86 setup code for i386

    This patch hooks the new x86 setup code into the Makefile machinery.  It
    also adapts boot/tools/build.c to a two-file (as opposed to three-file)
    universe, and simplifies it substantially.

    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 6560eb5b7e40d93813276544bced8c478f9067f5 fe5f90d9ca08e526559815789175602ba2c51743 M      arch

 
--  
Regards
 
       Joerg
 


----- Ursprüngliche Mail ----
Von: Jordan Crouse <jordan.crouse@amd.com>
An: Joerg Pommnitz <pommnitz@yahoo.com>
CC: cebbert@redhat.com; linux-kernel@vger.kernel.org
Gesendet: Dienstag, den 25. September 2007, 17:04:52 Uhr
Betreff: Re: Problems with 2.6.23-rc6 on AMD Geode LX800

On 25/09/07 01:38 -0700, Joerg Pommnitz wrote:
> Chuck, Jordan,
> thanks for taking an interest in this problem. As suggested by Jordan I tried a new
> BIOS revision from
> http://www.digitallogic.ch/index.php?id=256&dir=/MSEP800%20-%20SM800PCX%20%20-%20MPC20%20-%20MPC21&mountpoint=23
> 
> Unfortunately the kernel still fails to boot in the same way.

You'll have to contact Digital Logic and have them check with the BIOS vendor
to see if the fix was made in that version or not.  I don't have that
particular board, so I can't try out the fixes here.

I'm still trying to track down the particulars of the fix from the BIOS 
vendor.  I'll let you know.

> Do you still need the disassembled reserve_bootmem_core? 

Sure - you might as well - just to make sure its the same problem.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.








      __________________________________  
Yahoo! Clever: Sie haben Fragen? Yahoo! Nutzer antworten Ihnen. www.yahoo.de/clever

