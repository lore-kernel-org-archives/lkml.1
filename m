Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbZA3Aba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbZA3Aba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760473AbZA3AbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:31:14 -0500
Received: from web25805.mail.ukl.yahoo.com ([217.12.10.190]:46306 "HELO
	web25805.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760369AbZA3AbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:31:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PQBdUOH/F8uikP/9zmJDAvzB3ItvfgQhfwvhjThiKSOpcCTORkDDayNYJ01ek2u8vAoJISwLouNHv7Mmo1pdNDx/oRQjdizKFbXmIDaPBaIxGlhwhtE3uZneCQwUt8+Hr/MdacwUge62q6zsg1ULBkCxacJlmmkW+CJ+dZfSWVk=;
X-YMail-OSG: eKxTHaYVM1mISlsuyuIzPkQhInMoTsBFhga73OEB6hjFup2Ddjp4gvnK76lMXTN3kfFCaiyEPU83ltKjX3e.PStAChVTsyir0MX3oGPWFZzg0ETda3l0D.VQ6a5aK_WfsnW2FpzKN4CzbSlF8hDBoqIYUVLYZQSS.qcCOCBiV8FWhHdDmOLgDzA5HNXqHeay7_fCZpVUOnfghLSySqU_gLp056b8zgd0
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <54747.12003.qm@web25801.mail.ukl.yahoo.com> <871vul3g14.fsf@devron.myhome.or.jp> <49822E2A.3020601@zytor.com>
Date: Fri, 30 Jan 2009 00:31:08 +0000 (GMT)
From: A B <spinflipper4@yahoo.co.uk>
Subject: Re: Fat64 / exFat fs and Linux
To: "H. Peter Anvin" <hpa@zytor.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <957266.96237.qm@web25805.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> 
> Ok, I've put the patchset to,
> 
>     http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz
> 
> exfat/series is patch order to apply, and exfat/patches/* is patches.
> 
> It would be temporary place, well, anyway, this is my lastest version.
> 

Thanks for the code, I patched it into 2.6.28.2 and tried it on a 128MB USB
volume filled with many files. The driver correctly read 73% of the files.
Impressive. Looking at the others, they seemed to have what I would call
'alignment problems'.

md5sum: WARNING: 1008 of 3842 computed checksums did NOT match

Cheers,
Max



      
