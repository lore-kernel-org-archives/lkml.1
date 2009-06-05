Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZFEMoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZFEMoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFEMnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:43:52 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63265 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZFEMnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bqmBDWWRfj1BW6uY1TfJYNX3xEZvrLU66W7yyjoWy+qZ7deqs34eeadATRUSS3ktgd
         pIqTpamLnVCzR41uVCHwrnWjakbbB5QwRJw66niVCdXfcPUpWvkP+P7WCVTgWHQvkFXa
         MbGff7CE+RoltjacV3vDtroI9npDQNS7CyPrs=
MIME-Version: 1.0
In-Reply-To: <20090605114245.175499e1@lxorguk.ukuu.org.uk>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	 <20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	 <c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
	 <20090605100505.41b3b818@lxorguk.ukuu.org.uk>
	 <c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
	 <20090605114245.175499e1@lxorguk.ukuu.org.uk>
Date: Fri, 5 Jun 2009 14:43:51 +0200
Message-ID: <c5bd819b0906050543l42320f0r44e0306a7638b1b9@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/5 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> I've relayed your reply to the pata_amd user on the forum. As for my
>> case with pata_via, until this is fixed, is there any way to force it
>> to use a higher UDMA? Is there a flag that can be passed in, for
>
> In your case given the BIOS appears to be informing us you have a 40wire
> cable there isn't much that can be fixed
>
>> example, in /sys somewhere? hdparm fails to set a higher UDMA and I
>> looked at sdparm but don't see anything in it to increase UDMA...
>
> Tejun some time ago added stuff to override all of these things:
>
> See Documentation/kernel-parameters.txt
>
>        libata.force=
>
> which will let you override all sorts of autodetection for quirky boards
>

Thanks, I will try out the kernel params. However, I still wonder why
older kernels have no problems setting the correct UDMA while 2.6.30
does have problems. Something must have definitely changed in this
latest kernel. I'll go dig in my BIOS to see if I may need to
change/force something.
