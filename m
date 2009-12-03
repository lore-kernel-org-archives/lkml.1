Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZLCWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZLCWCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZLCWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:02:49 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:35073 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751794AbZLCWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:02:48 -0500
Message-ID: <4B18357E.9050900@ru.mvista.com>
Date: Fri, 04 Dec 2009 01:02:38 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912031339.14440.bzolnier@gmail.com> <4B17FB37.2030501@garzik.org> <200912032045.48728.bzolnier@gmail.com> <4B182A9F.5090708@garzik.org>
In-Reply-To: <4B182A9F.5090708@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>>        pata_efar: MWDMA0 is unsupported
>
> skipped, pending discussion (just sent email)

   There's basically nothing to discuss -- the PIIX like chips don't 
support MWDMA0 (with an acceptable cycle length, if at all, anyway). The 
way the driver is written, MWDMA0 is simply programmed overclocked.

>
>>        pata_hpt3x2n: fix overclocked MWDMA0 timing
>
> skipped, pending discussion (just sent email)


   Nothing to discuss either, this looks like a single digit typo to me...

>
>>        pata_hpt3x3: Power Management fix
>
> applied, on a hope and a prayer (did not see this posted to mailing 
> list?).

   http://marc.info/?l=linux-ide&m=125916980522990

>
>>        pata_it8213: MWDMA0 is unsupported
>
> skipped, pending discussion (just sent email)

   Nothing to discuss...

>        pata_oldpiix: MWDMA0 is unsupported
>
> skipped -- Alan, Sergey, comments?

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

>
>>        pata_rdc: MWDMA0 is unsupported
>
> skipped -- Alan, Sergey, comments?

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


