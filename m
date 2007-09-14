Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbXINRND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbXINRND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXINRMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:12:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14380 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbXINRMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DXCPAE8iJexp438ZIgjy5KsjwMqD1dQHwVPvi7ihN7SzOw0GahwLxkTX/57967LGkNSfNr/KieBkOh+CwXTWtGelqEnDjnv3XGNQKJUdEHDUot4MNI6PbOdk2zTG735ECMSlubQG/SlRL2gtmzBnn2MtlL65t2PHT57Qd/5KD0k=
Message-ID: <86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>
Date: Fri, 14 Sep 2007 10:12:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Howard Chu" <hyc@symas.com>
Subject: Re: MTRR initialization
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46EAB7DA.10507@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EAB7DA.10507@symas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Howard Chu <hyc@symas.com> wrote:
> Hi, was wondering if anyone else has been tripped up by this... I've got 4GB of
> RAM in my Asus A8V Deluxe and memory hole mapping enabled in the BIOS. By
> default, my system boots up with these MTRR settings:
>
> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1

BIOS should have another setup option about MTRR (continous?)
then you could get

> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x100000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
===> if you have rev E...instead of rev F.

YH
