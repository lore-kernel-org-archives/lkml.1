Return-Path: <linux-kernel-owner+w=401wt.eu-S936607AbXHLRHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936607AbXHLRHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbXHLRHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:07:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55045 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbXHLRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:07:20 -0400
Date: Sun, 12 Aug 2007 19:07:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: Valdis.Kletnieks@vt.edu, roland <devzero@web.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Software based ECC ?
In-Reply-To: <20070812165131.GG7973@vanheusden.com>
Message-ID: <Pine.LNX.4.64.0708121904220.28963@fbirervta.pbzchgretzou.qr>
References: <000a01c7db93$c75b66c0$eeeea8c0@aldipc> <12507.1186812675@turing-police.cc.vt.edu>
 <20070812165131.GG7973@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 18:51, Folkert van Heusden wrote:
>
>> > http://pdos.csail.mit.edu/papers/softecc:ddopson-meng/softecc_ddopson-meng.pdf
>> > "SoftECC : A System for Software Memory Integrity Checking"
>> 
>> Personally, I'd recommend just shelling out the bucks for hardware ECC if
>> the reliability matters.
>
>a question and an idea: Q: is ecc guaranteed to detect all bitflips?
>
>Idea: what about a multicore system (3 or more) that runs the same
>processes on 2 cores and a third core verifying that they both do the
>same? As I think it is not only ram that can become faulty.

Indeed. And for example BOINC (Seti@home) have to consider this. Hence they
recalculate each work unit at least three times and then compare between
each. What makes this different from ECC is that the checksum is not calculated
on every memory operations, but at the end of a larger block of operations. Of
course this may mean that an error can propagate for a while, but the total
walltime (including recomputation) is lower. :)


	Jan
-- 
