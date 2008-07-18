Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYGRIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYGRIZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYGRIZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:25:01 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:2923 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYGRIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wBk5lzNB0+OuT5SeGuwDeaeuWJLyLmnh96FdqkumdalystBVBNaWA4gZtztgI/ByE4
         8ffvlq+iakWnpudUhtHrqSbV2mngk/gBXoJWEhug7bx6+diRrl0mUoKSJ2KaYtYbmvIU
         wVgZFj0cnia82yP5iqTlyD9RM1nZiArViFOeU=
Message-ID: <aec7e5c30807180124j3623675fwaeedcaf23e4b0b05@mail.gmail.com>
Date: Fri, 18 Jul 2008 17:24:59 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [PATCH 02/05] resource: add resource_type() and IORESOURCE_TYPE_BITS
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, gregkh@suse.de,
       lethal@linux-sh.org, i2c@lm-sensors.org, akpm@linux-foundation.org
In-Reply-To: <20080718075601.GL24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
	 <20080718074018.32713.11976.sendpatchset@rx1.opensource.se>
	 <20080718075601.GL24620@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 4:56 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> You are changing a simple test to a mask and compare, is anyone going
> to produce resources with an IORESOURCE_MEM and an IORESOURCE_IO
> together?

Actually, I'd like to replace the one-bit-per-type strategy with a
N-bit counter. But that is not very compatible with the case you are
pointing out. I'm not sure if that's a combination we really want to
support though. Both IRQ and DMA doesn't make much sense to me. =)

/ magnus
