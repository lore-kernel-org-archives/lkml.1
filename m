Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZJBCVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZJBCVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZJBCVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:21:51 -0400
Received: from smtp114.rog.mail.re2.yahoo.com ([68.142.225.230]:43987 "HELO
	smtp114.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212AbZJBCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 22:21:50 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 22:21:50 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Ls8g5/ADeVUHjOUqswuHiuULb/WF7PLz+zK09hLSAaSGbXY0T+mOAvkCIJsLngHYFR5vF1EdOKj3kDrm/kKnSL44QRsyMX7oBeUeQ89Dmeh1MOMYSqIyXAo0ZuAta8Wd+6jjG6XrnnxGBS3nfrwSBgxXymCaka6nM9rKqiofARA=  ;
X-YMail-OSG: nh8J4n4VM1lpROBEvJdk6VPWfsqx2nThNjAcaXh3ISAcqkRskAUx_ct7k2FKmfSTAA--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER  DVD-RW  DVR-111D
Date: Thu, 1 Oct 2009 22:15:03 -0400
User-Agent: KMail/1.12.90 (Linux/2.6.31.1-custom; KDE/4.3.69; x86_64; svn-1027797; 2009-09-23)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910012215.04621.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Model is: 
Unable to burn DVDs with 2.6.31.x

ata7.00: ATAPI: PIONEER DVD-RW  DVR-111D, 1.29, max UDMA/66
scsi 6:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.29 PQ: 0 ANSI: 5

sr 6:0:0:0: [sr0] Unhandled sense code                                                                                      
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE                                                           
sr 6:0:0:0: [sr0] Sense Key : Medium Error [current]                                                                        
Info fld=0x0                                                                                                                
sr 6:0:0:0: [sr0] Add. Sense: L-EC uncorrectable error                                                                      
end_request: I/O error, dev sr0, sector 0                                                                                   
Buffer I/O error on device sr0, logical block 0                                                                             

wodim (cdrecord):

Errno: 5 (Input/output error), reserve track scsi sendcmd: no error
CDB:  53 00 00 00 00 00 1D 60 3C 00
status: 0x2 (CHECK CONDITION)
Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 00 00 00
Sense Key: 0x5 Illegal Request, Segment 0
Sense Code: 0x21 Qual 0x00 (logical block address out of range) Fru 0x0
Sense flags: Blk 0 (not valid)
cmd finished after 0.006s timeout 40s
wodim: Cannot open new session.

I thought maybe this was due to something with kernel config but I'm not sure 
now. This used to work fine.

Anyone also able to confirm something broke or if I'm enabling something in 
.config I shouldn't be?

Thanks, 
Shawn.
