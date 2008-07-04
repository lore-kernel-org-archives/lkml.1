Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYGDXhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYGDXhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYGDXhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:37:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:37795 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYGDXhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:37:33 -0400
In-Reply-To: <20080703010308.26187.23037.stgit@trillian.secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca> <20080703010308.26187.23037.stgit@trillian.secretlab.ca>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1694b01b1b41f244e565298b430f021c@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       david-b@pacbell.net, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH v2 3/5] of-bindings: Add binding documentation for SPI busses and devices
Date: Sat, 5 Jul 2008 01:36:58 +0200
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +    The SPI master node requires the following properties:
> +    - #address-cells  - number of cells required to define a chip 
> select
> +			address on the SPI bus.

Hrm.  Should this (and "reg" in the child node) be required for SPI
masters that have only one chip select?

> +    - max-speed       - (required) Maximum SPI clocking speed of 
> device in Hz

The property name should include something "SPI", it's way too generic
otherwise.

> +    - spi,cpol        - (optional) Device requires inverse clock 
> polarity
> +    - spi,cpha        - (optional) Device requires shifted clock phase

Don't abbr the property names, there's nothing wrong with longer names.
The names shouldn't start with "spi," either, "spi" isn't a vendor;
how about "spi-inverse-clock-polarity" or similar?

> +    - linux,modalias  - (optional, Linux specific) Force binding of 
> SPI device
> +			to a particular spi_device driver.  Useful for changing
> +			driver binding between spidev and a kernel SPI driver.

This is a temporary workaround I hope?


Segher

