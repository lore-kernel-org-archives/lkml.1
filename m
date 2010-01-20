Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954Ab0ATGsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0ATGsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359Ab0ATGsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:48:23 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53651 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0ATGsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:48:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wnOpN+4mOAAhAGH+Deo+IdxdFoCp3VMuCf/dlDitHbOLl28yX05Hw6ui6WJG2f+dhv
         ocqFWTIUffm1tBUW103JF4I0VOpCWB9XdAVQrQ4tz1Z6qlfgcN0fdXtWuE0Kb3hptIMq
         XHJFU7HYhVJmvw3AybMwNeLuWFHij+i42DEv8=
Message-ID: <4B56A8A0.3050309@gmail.com>
Date: Wed, 20 Jan 2010 15:54:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bart Hartgers <bart.hartgers@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       juergen.metzdorf@telelev-dsl.de, markpschool@hotmail.com,
       sporadic.crash@gmail.com, apopov@sirma.bg, david@coomber.co.za,
       jay4mail@gmail.com
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA
 	write
References: <20100116235653.898098245@gmail.com>	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com>	 <4B568C63.4050506@gmail.com> <7eb6a4d81001192233i5418249ct5a1717045f75167c@mail.gmail.com>
In-Reply-To: <7eb6a4d81001192233i5418249ct5a1717045f75167c@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/20/2010 03:33 PM, Bart Hartgers wrote:
> Well, the ata_sff_pause actually does a ndelay(400), and with today's
> processors that would be a 'slow path', right?

unlikely() is used to mark very unlikely paths not the slow ones and I
don't really think DMA_TO_DEVICE would qualify as an unlikely path.

Thanks.

-- 
tejun
