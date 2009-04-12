Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZDLCqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZDLCqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 22:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZDLCqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 22:46:36 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42412 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZDLCqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 22:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uJBtBTvZSUUclB8Qn1Y5AnzjFut+sQjn9IomMJknmBOmyRmsoHNB9rSYom5qMu6jIt
         ybBs9VMpFxMFN08kiiqfgVBDGXtxL1HuvTN8uU+Icex58rcoodFnSJ2Ot/XIqteCGBgt
         Q3GhlxjvR1cwf8BMwhzPSHvFMsYmTsIZr3X4A=
MIME-Version: 1.0
In-Reply-To: <20090408200511.GA24071@havoc.gtf.org>
References: <20090408200511.GA24071@havoc.gtf.org>
Date: Sun, 12 Apr 2009 06:46:33 +0400
Message-ID: <a4423d670904111946w2a8f3839n27b77f5473076563@mail.gmail.com>
Subject: Re: [PATCH] sata_sx4: refresh and convert to new EH
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/9 Jeff Garzik <jeff@garzik.org>:
>
> I reviewed and refreshed libata-dev.git#new-eh, now renamed to #sx4.
>
> Several bugs and missing pieces in the new-EH conversion were addressed
> (often by copying highly similar code from sata_promise, a highly
> similar chip)
>
> The only thing left is some "it still works" testing...  any takers?
>

Hi Jeff

I have SX4000 card, it is based on the same PDC20621 chip, but has PATA ports
(without PATA-SATA bridges).
Can I help?

I am newbie here, but I will try to modify the driver to support PATA
card as well
and test your patch.
