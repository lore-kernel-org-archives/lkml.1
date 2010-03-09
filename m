Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0CIBVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:21:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:59996 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab0CIBVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:21:07 -0500
Message-ID: <4B95A27E.9010302@kernel.org>
Date: Tue, 09 Mar 2010 10:21:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B67A149.10406@kernel.org> <d2d378041002170814l1da6b022p4902128c604fc84b@mail.gmail.com> 	<4B7C9CEE.4080902@kernel.org> <d2d378041002201111g7af41a3dpdb2fa300a65d56bf@mail.gmail.com> 	<4B8085E7.5000501@kernel.org> <d2d378041002211328w6355d2f9ued625de53964cee5@mail.gmail.com> 	<4B833FA1.8030207@kernel.org> <d2d378041002280924q26b4a159g5ad22a3476ec3e18@mail.gmail.com> 	<4B8CFAF4.7030303@kernel.org> <d2d378041003081117i63d807a5mefcb6ea113f026a4@mail.gmail.com>
In-Reply-To: <d2d378041003081117i63d807a5mefcb6ea113f026a4@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 01:21:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 04:17 AM, Cengiz Günay wrote:
> Hello,
> 
> Sorry for the delay, I was confused about managing so many patches,
> but I realized that you're sending me cumulative patches that I can
> apply to the original. I just want to remind you that I still have the
> patches to the other two files: libata-eh.c  libata-sff.c
> 
> On Tue, Mar 2, 2010 at 6:48 AM, Tejun Heo <tj@kernel.org> wrote:
>> Hmmm... the drive is timing out even on 4k READ10's.  This shouldn't
>> really be happening.  Can you please try this one?
> 
> Applied. It did not change anything visibly (dmesg attached). I have
> also been getting other SCSI errors since we started communicating
> with the device (search for sr0 in dmesg). I wonder if they give any
> hints? Here's one:
> 
> sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sr 4:0:0:0: [sr0] Sense Key : Aborted Command [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 00 00 00 00 00 0e 09 0c 00 00 00 02 00 00
>         00 20 00 00 a0 40
> sr 4:0:0:0: [sr0] Add. Sense: No additional sense information
> sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 40 00
> end_request: I/O error, dev sr0, sector 0

Hmmm... can you please post full dmesg?

-- 
tejun
