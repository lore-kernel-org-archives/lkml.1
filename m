Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXLNUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXLNUV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbXLNUVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:21:49 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:56303 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751951AbXLNUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wkzsri0MVKVpEZ1lzmV1IKxuo3qUNy+00+8Ip/hkvSgyQpXk5DzWGieRMJ9KCNWfpwKF0b/GWe+CnrXuYUmwSEuW1EmRP2og5iE7xMcyl1gU9wckXHdQM0jdpD+TmhT160MWBPqzTZXIhXk4c1P6/ZXO54LHI8hCQ04aZVkqbBo=
Message-ID: <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com>
Date: Fri, 14 Dec 2007 15:21:45 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: Working upstream toolchain for avr32?
Cc: "Adrian Bunk" <bunk@kernel.org>, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071214200318.GM3851@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213195617.GF21616@stusta.de>
	 <20071214200318.GM3851@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 3:03 PM, Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> On Thu, Dec 13, 2007 at 08:56:17PM +0100, Adrian Bunk wrote:
> > AFAIK the latest available AVR32 toolchains are some patched gcc 4.0 and
> > some patched binutils 2.17, and avr32 is currently the only architecture
> > in the kernel where upstream of both of them is not capable of building
> > a kernel for the architecture.
>
> Is an upstream toolchain available which is able to build blackfin?

binutils -- yes
uClibc -- yes (for FLAT)
gcc -- yes and no

we have some pieces in gcc, but if you want an
up-to-date-tested-known-working combination, you can fetch
sources/binaries from:
http://blackfin.uclinux.org/gf/project/toolchain/frs

we're working now to make sure that when gcc-4.3 is branched/released,
we're part of it
-mike
