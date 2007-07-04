Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbXGDIw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbXGDIw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbXGDIwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:52:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:39204 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbXGDIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=heJ2lKnseGZopxRXFKkPgFx3QFtxJLveQVHb2QmPb7nov1GYVci9hklp34dvsQzUBERt8bYwFyndi/opN2qfLqlvQc8Ueypk4cPvnoKnKYYWUClMMvdB1mbzqATrTOR3HUQ2GDQJiiEbEtYsRFUr2havNO7hUktzcL9tIhkzLq4=
Message-ID: <468B5FBD.3040104@gmail.com>
Date: Wed, 04 Jul 2007 17:52:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: 7091@blargh.com, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil, writing bug with multiple cards?
References: <courier.4689EFD9.0000589A@blargh.com> <200707040908.21512.ak@suse.de> <courier.468B579E.00002ECF@blargh.com> <200707041038.57677.ak@suse.de>
In-Reply-To: <200707041038.57677.ak@suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 04 July 2007 10:17:34 7091@blargh.com wrote:
> 
>>> Most likely it is some sort of hardware bug that we might
>>> not be able to do much about. Have you tried contacting SIL or VIA? 
>> No, I haven't.  Like I mentioned above, the OpenBSD drivers seemed to work, 
>> or at least did with similar tests.  I would need to run the more extensive 
>> checks to be positive, but those take a lot of time, obviously.  And 
>> downtime for the box, a lot of which isn't really manageable, at the moment. 
> 
> Perhaps the OpenBSD drivers program the SIL chip in a different way
> that avoids this problem. 
> 
>>> e.g. if you have some other system with a different chipset it might
>>> be useful to test the SIL controllers in those.
>> The previous motherboard was an AMD 760 chipset, and it had the same 
>> problem. 
> 
> Ok this means it's likely a SIL issue, not a chipset issue.

Hmmmm... okay.  I'll take look at the openBSD driver.  I still have no
idea what it can be tho.  Maybe, FIFO setup?

Thanks.

-- 
tejun
