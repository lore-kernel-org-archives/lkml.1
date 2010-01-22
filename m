Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992Ab0AVRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0AVRhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958Ab0AVRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:37:32 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63576 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0AVRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:37:31 -0500
MIME-Version: 1.0
In-Reply-To: <20100122042708.GK10014@trinity.fluff.org>
References: <20100122152152.5666ccab.sfr@canb.auug.org.au> 
	<20100122042708.GK10014@trinity.fluff.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 22 Jan 2010 10:31:43 -0700
X-Google-Sender-Auth: 3eb9093cbd861b13
Message-ID: <fa686aa41001220931g225ed20dg3909bb254585bb80@mail.gmail.com>
Subject: Re: linux-next: spi tree build failure
To: Ben Dooks <ben-linux@fluff.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 9:27 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Fri, Jan 22, 2010 at 03:21:52PM +1100, Stephen Rothwell wrote:
>> Hi Grant,
>>
>> Today's linux-next build (x86_64 allmodconfig) failed like this:
>>
>> ERROR: "clk_get_rate" [drivers/spi/dw_spi_mmio.ko] undefined!
>> ERROR: "clk_enable" [drivers/spi/dw_spi_mmio.ko] undefined!
>> ERROR: "clk_get" [drivers/spi/dw_spi_mmio.ko] undefined!
>> ERROR: "clk_put" [drivers/spi/dw_spi_mmio.ko] undefined!
>> ERROR: "clk_disable" [drivers/spi/dw_spi_mmio.ko] undefined!
>>
>> Caused by commit f7b6fd6d1d3833529f1626c761ba7e338586d35e ("Memory-mapped
>> dw_spi driver").
>
> sounds like someone forgot to tmake the driver dependant on HAVE_CLK

Gah!  I did a test build of the module with allmodconfig, but I didn't
let it get to the modpost stage ('cause I'm building on my dinky
laptop which takes forever).  Sorry.  I've picked up the fix and
pushed out.  Today's tree should be better.  I'm not picking up
anything new today.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
