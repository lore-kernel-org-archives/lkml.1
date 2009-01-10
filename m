Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZAJNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZAJNBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZAJNBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:01:11 -0500
Received: from h155.mvista.com ([63.81.120.155]:63678 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813AbZAJNBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:01:09 -0500
Message-ID: <49689C38.1040607@ru.mvista.com>
Date: Sat, 10 Jan 2009 16:01:44 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com>	<200901101009.13699.borntraeger@de.ibm.com>	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>	<200901101242.05203.borntraeger@de.ibm.com>	<49688B63.5030105@ru.mvista.com> <20090110122130.318cf168@lxorguk.ukuu.org.uk>
In-Reply-To: <20090110122130.318cf168@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>   That's the typical REQUEST SENSE command with 18-byte data length.

> Which means something has become horribly broken in the core libata stack.
> An 18 byte inquiry would have 18 bytes as the *last* sg element. That

    Did you get me right? 18 bytes is the typical REQUEST SENSE payload 
(libata requested 96 bytes), not INQUIRY. For the INQUIRY 36 bytes was 
requested and received (divisible by 4).
    And I doubt there can be more than one S/G segment with such lengths...

WBR, Sergei
