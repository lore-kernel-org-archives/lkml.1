Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949Ab0ASHAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0ASHAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366Ab0ASHAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:00:46 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60042 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0ASHAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:00:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M1zILjIhCk7UhKt3hZ9FERIWT6zHflg1Du/tqSbTEzcEPJvDGxqzN0VjnLfnHzrx3N
         LgmpNFucw7uD0L2gYbCAu1dqO/kji2Ok8+lZIj1crUJdntTlbnm8xMh57y3QVLXRucLZ
         a1ESwOgR9ujd2TblM1E4aoJXb2LlWbYOFCbyY=
MIME-Version: 1.0
In-Reply-To: <4B55130D.8070503@gmail.com>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <4B484829.6060405@kernel.org>
	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
	 <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com>
	 <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
	 <4B536383.7090609@gmail.com>
	 <64bb37e1001171311u21c58fbj9a13b6aaeb7b2c3f@mail.gmail.com>
	 <64bb37e1001181251y733513cdm1be9850af880ee73@mail.gmail.com>
	 <4B55130D.8070503@gmail.com>
Date: Tue, 19 Jan 2010 08:00:43 +0100
Message-ID: <64bb37e1001182300u13f41817hf1a3d18ffdc75847@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 3:03 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 01/18/2010 02:51 PM, Torsten Kaiser wrote:
>> Should I try to put some printks in arch/x86/kernel/apic/io_apic.c
>> __assign_irq_vector() or is there a better way to look at the irq
>> vectors?
>
> Might not be a bad idea.

OK, I will try it later today.

> Something definitely seems to be banging on vector
> 165. Any references to 165 in dmesg prior to that? I wonder where that is
> coming from..

No, grepping for 165 only shows some timestamps and some output from
the serial driver, because that's a 16550A.

I hope adding these debugs will help, maybe something suspicious
reserved 164 or 166...


Torsten
