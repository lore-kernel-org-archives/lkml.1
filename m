Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYGDXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYGDXm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYGDXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:42:48 -0400
Received: from ag-out-0708.google.com ([72.14.246.247]:22733 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYGDXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:42:48 -0400
Message-ID: <fa686aa40807041642m1ecd1f8fr33382076ca5c11fa@mail.gmail.com>
Date: Fri, 4 Jul 2008 17:42:46 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Subject: Re: [PATCH v2 3/5] of-bindings: Add binding documentation for SPI busses and devices
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       david-b@pacbell.net, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com
In-Reply-To: <1694b01b1b41f244e565298b430f021c@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
	 <20080703010308.26187.23037.stgit@trillian.secretlab.ca>
	 <1694b01b1b41f244e565298b430f021c@kernel.crashing.org>
X-Google-Sender-Auth: c36a184eaaeb550d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 5:36 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>> +    The SPI master node requires the following properties:
>> +    - #address-cells  - number of cells required to define a chip select
>> +                       address on the SPI bus.
>
> Hrm.  Should this (and "reg" in the child node) be required for SPI
> masters that have only one chip select?

I suppose it could be skipped, but I'd rather have it there for consistency

>
>> +    - max-speed       - (required) Maximum SPI clocking speed of device
>> in Hz
>
> The property name should include something "SPI", it's way too generic
> otherwise.

Good point; I'll change this to 'spi-max-speed'

>> +    - spi,cpol        - (optional) Device requires inverse clock polarity
>> +    - spi,cpha        - (optional) Device requires shifted clock phase
>
> Don't abbr the property names, there's nothing wrong with longer names.
> The names shouldn't start with "spi," either, "spi" isn't a vendor;
> how about "spi-inverse-clock-polarity" or similar?

Okay, but cpol and cpha are common abbreviations w.r.t. SPI devices.

>> +    - linux,modalias  - (optional, Linux specific) Force binding of SPI
>> device
>> +                       to a particular spi_device driver.  Useful for
>> changing
>> +                       driver binding between spidev and a kernel SPI
>> driver.
>
> This is a temporary workaround I hope?

Yeah, I'm kind of ashamed of this one.  I'll drop it.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
