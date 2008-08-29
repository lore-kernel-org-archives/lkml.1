Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYH2Dsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYH2Dsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 23:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYH2Ds3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 23:48:29 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:31671 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751214AbYH2Ds2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 23:48:28 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 23:48:28 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.ar;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=rwdJ29IFm1eHTWijwLi5i51UOzQijEV9vWXxX2psHp6U2G4ewYXm/f0NgOiCQxV08vwBe6DseYXf5VozsnhzC53SMCgx7pIeFGJrO75Iri9Rq+5qp4Q+2TnYa2aT2gUgohIZOV7I+nu2a/igaQGOZ2X5lKUxVpv24irZu1UK4xg=  ;
X-YMail-OSG: 7YcL3tQVM1m2yMMKQIRfmnLZOuumwHPWW.C1K7KBld3iL29SF6eRRbYGGb.vpFt5jSz6oJC6oPM5YfcU9nHyI6Rd.34F6eptDC51uq0d_7h2ODqJw.QWJg04pV0_wxmFWX5fGOGzHY1uc4yWw76MdAdTyOeyl_imYLb_
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48B76FF5.6010507@yahoo.com.ar>
Date: Fri, 29 Aug 2008 00:41:41 -0300
From: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jari.aalto@cante.net
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

(sorry my english)

When booted kernel with no iommu parameter, it uses the iommu gart (from amd) and the size of the aperture is 64MB
You can try to grow this size with iommu=memaper=2 for 128MB or 3 for 256MB. I don't have experience with this, but 
i read that this, solves the problem.

I have the similar hardware, but when boot in 64 bits, limit the memory with mem=4G (discarded 0.5G that are (remaped from pci space) beyond 4G)
and iommu=noaperture. (This is not option for you, will be discard 4G of RAM)


Asus M2N32-SLI DELUXE (BIOS Phoenix ver 1603 [12/17/2007])
4 x 1GB OCZ DDR2 PC2-6400 Platinum Rev2 ( OCZ2P800R21G )
AMD Athlon 64 X2 5200+ ( ADA5200IAA6CS ) (stepping F2)

I have realiced some test an posted here (sorry in spanish): http://www.pcmasmas.com/viewtopic.php?t=31445


Buena suerte.


Jari Aalto <jari.aalto <at> cante.net> writes:

> Initially when the PC was installed (and had no IOMMU) options, that
> cause the whole harddisk to corrupt and I had to reinstall everything.
> It might have been a little older kernel (2.6.23?), but I don't recall
> it exactly.

> According to messages in syslog I tried to track down similar incidents
> and found the iommu articles. But the information was like trial and
> error.

> Would you suggest that "immu=off" would be best option?


-- 
Gerardo Exequiel Pozzi ( djgera )
http://www.djgera.com.ar
KeyID: 0x1B8C330D
Key fingerprint = 0CAA D5D4 CD85 4434 A219  76ED 39AB 221B 1B8C 330D

