Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYEXXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYEXXH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYEXXHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 19:07:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:44813 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYEXXHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 19:07:18 -0400
In-Reply-To: <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <20080523182842.GB469@polina.dev.rtsoft.ru> <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5779f808f6188a88231bf2a8c49e52d5@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Gary Jennejohn <garyj@denx.de>, linuxppc-dev@ozlabs.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi driver
Date: Sun, 25 May 2008 01:06:08 +0200
To: "Grant Likely" <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +      Required properties:
>> +      - #address-cells : should be 0.
>> +      - #size-cells : should be 0.
>
> Are these properties required at all?  Will this node have any 
> children.

You mean, "does this node define a bus".  If it doesn't, there
shouldn't be #a and #s; if it does, the binding should describe
what the addressing is.  #a = #s = 0 describes a bus without any
addressing; pretty unusual :-)

>> +      - linux,mmc-ocr-mask : (optional) Linux-specific MMC OCR mask
>> +        (slot voltage).
>
> Should this property be better defined?

Yes please.  There's a good chance that it doesn't turn out to be
Linux-specific at all (after some modification, perhaps).


Segher

