Return-Path: <linux-kernel-owner+w=401wt.eu-S936249AbXLQVrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936249AbXLQVrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762027AbXLQVrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:47:43 -0500
Received: from powered.by.stone-is.net ([87.238.163.201]:44372 "EHLO
	vps.dupondje.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762847AbXLQVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:47:42 -0500
Message-ID: <4766EE29.5060706@dupondje.be>
Date: Mon, 17 Dec 2007 22:46:17 +0100
From: Jean-Louis Dupond <info@dupondje.be>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: John Stoffel <john@stoffel.org>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: 2.6.24-rc5: tape drive not responding
References: <18277.52079.718004.969358@stoffel.org>	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>	<20071217031510.c3d500fd.akpm@linux-foundation.org>	<18278.55130.471797.398922@stoffel.org>	<18278.58314.892734.490418@stoffel.org> <20071217134344.3f024461.akpm@linux-foundation.org>
In-Reply-To: <20071217134344.3f024461.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://marc.info/?l=linux-scsi&m=119770154127770&w=2

There is the patch for st.c

Andrew Morton schreef:
> On Mon, 17 Dec 2007 16:02:02 -0500
> "John Stoffel" <john@stoffel.org> wrote:
> 
>> Just to confirm, the propsed patch to st.c fixes the issue with
>> 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
>> drives.
> 
> err, what patch to st.c?
> 
> So it seems that 2.6.24 (and presumably 2.6.23?) need
> 
> 1: Alan's "initio: fix conflict when loading driver" (currently stocuk
>    in git-scsi-misc)
> 
> 2: Boaz's "initio: initio_build_scb() fix" (my name for it)
> 
> 3: The mystery st.c fix.
> 
> yes?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
