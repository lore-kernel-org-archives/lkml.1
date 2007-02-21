Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbXBUCzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbXBUCzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 21:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXBUCzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 21:55:53 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:20844 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbXBUCzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 21:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=p0wm1XjeSdf49wukcxpPF8bhIiB8+sV/94vg72Olz+Ipj5+wjahYNBP/CosKb0SKUknxhfCuvvyW+v8JLF+Hy6jNoyLN769JIJkMKSth0sgL+ypw/g4DYQcMu2QkEy1qAqiCiH2FFB/5YWFwoteCZT/dFhymYQ3kP5AmxJNJQ08=
Message-ID: <df47b87a0702201855j260b8862u3c41249ae5ae9fb1@mail.gmail.com>
Date: Tue, 20 Feb 2007 21:55:50 -0500
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
Cc: "Joel Soete" <soete.joel@scarlet.be>, "Luming Yu" <luming.yu@gmail.com>,
       "Alan Cox" <alan@redhat.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
In-Reply-To: <45CFBBD1.5090703@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_54750_22352000.1172026550251"
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>
	 <20061117100559.GA10275@devserv.devel.redhat.com>
	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>
	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>
	 <45BB51F9.5070100@scarlet.be>
	 <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com>
	 <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_54750_22352000.1172026550251
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 2/11/07, Tejun Heo <htejun@gmail.com> wrote:
> Please test the attached patch over 2.6.20.

No luck for me. I'm using pata_sis. Some error bits:

agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 16x mode
agpgart: SiS delay workaround: giving bridge time to recover.
agpgart: Putting AGP V3 device at 0000:01:00.0 into 16x mode
ata2.00: qc timeout (cmd 0xa0)
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: (BMDMA stat 0x24)
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x28 data 4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
ata2: port is slow to respond, please be patient (Status 0xd0)
ata2: port failed to respond (30 secs, Status 0xd0)
ata2: soft resetting port
ata2.00: configured for UDMA/33
ata2: EH complete
ata2.00: qc timeout (cmd 0xa0)
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: (BMDMA stat 0x24)
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x28 data 4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
ata2: port is slow to respond, please be patient (Status 0xd0)
ata2: port failed to respond (30 secs, Status 0xd0)
ata2: soft resetting port
ata2.00: configured for UDMA/33
ata2: EH complete
ata2.00: qc timeout (cmd 0xa0)
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: (BMDMA stat 0x24)
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x28 data 4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
ata2: port is slow to respond, please be patient (Status 0xd0)


Compressed dmesg attached. Thanks.

------=_Part_54750_22352000.1172026550251
Content-Type: application/x-gzip; name=dmesg.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: file1
Content-Disposition: attachment; filename="dmesg.gz"

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
liTgSgAA
------=_Part_54750_22352000.1172026550251--
