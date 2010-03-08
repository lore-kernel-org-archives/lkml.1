Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0CHXqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:46:48 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:48662 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0CHXqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XzkAcYI3kxl6/LbPbRbtLJpd9+nn5Va8lbWTJRg2bVoRRTH1iXmGNVe6r5/SNK0KO8
         Q0zAW6WyYutYuhbjRaE7xWGbfI2o8UpfxFaEPiEDCgejcvRXdoy8PfQjOyLHq1A73P+d
         rxpYimZSP8j1iGSNYKRNcyuqzD3sEr9by0xoo=
MIME-Version: 1.0
In-Reply-To: <d2d378041003081117i63d807a5mefcb6ea113f026a4@mail.gmail.com>
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu>
	 <d2d378041002170814l1da6b022p4902128c604fc84b@mail.gmail.com>
	 <4B7C9CEE.4080902@kernel.org>
	 <d2d378041002201111g7af41a3dpdb2fa300a65d56bf@mail.gmail.com>
	 <4B8085E7.5000501@kernel.org>
	 <d2d378041002211328w6355d2f9ued625de53964cee5@mail.gmail.com>
	 <4B833FA1.8030207@kernel.org>
	 <d2d378041002280924q26b4a159g5ad22a3476ec3e18@mail.gmail.com>
	 <4B8CFAF4.7030303@kernel.org>
	 <d2d378041003081117i63d807a5mefcb6ea113f026a4@mail.gmail.com>
Date: Mon, 8 Mar 2010 17:46:44 -0600
Message-ID: <51f3faa71003081546x1694780q490f7e07bc9ddb5b@mail.gmail.com>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
From: Robert Hancock <hancockrwd@gmail.com>
To: =?ISO-8859-1?Q?Cengiz_G=FCnay?= <cgunay@emory.edu>
Cc: Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/8 Cengiz Günay <cgunay@emory.edu>:
> Hello,
>
> Sorry for the delay, I was confused about managing so many patches,
> but I realized that you're sending me cumulative patches that I can
> apply to the original. I just want to remind you that I still have the
> patches to the other two files: libata-eh.c  libata-sff.c
>
> On Tue, Mar 2, 2010 at 6:48 AM, Tejun Heo <tj@kernel.org> wrote:
>> Hmmm... the drive is timing out even on 4k READ10's.  This shouldn't
>> really be happening.  Can you please try this one?
>
> Applied. It did not change anything visibly (dmesg attached). I have
> also been getting other SCSI errors since we started communicating
> with the device (search for sr0 in dmesg). I wonder if they give any
> hints? Here's one:
>
> sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sr 4:0:0:0: [sr0] Sense Key : Aborted Command [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 0b 00 00 00 00 00 0e 09 0c 00 00 00 02 00 00
>        00 20 00 00 a0 40
> sr 4:0:0:0: [sr0] Add. Sense: No additional sense information
> sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 40 00
> end_request: I/O error, dev sr0, sector 0

Don't think that part's very useful, that's just the after-effect of
the timeouts in the driver..
