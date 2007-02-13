Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbXBMJGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbXBMJGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXBMJGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:06:41 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:4268 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXBMJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:06:39 -0500
Message-ID: <45D17F9C.2010509@ribosome.natur.cuni.cz>
Date: Tue, 13 Feb 2007 10:06:36 +0100
From: =?ISO-8859-1?Q?Martin_MOKREJS=28?= 
	<mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070212 SeaMonkey/1.1
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.19.1: kernel BUG at mm/slab.c:2911!
References: <45BF2418.9010002@ribosome.natur.cuni.cz> <Pine.LNX.4.64.0702121610240.19380@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702121610240.19380@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 30 Jan 2007, Martin MOKREJS wrote:
> 
>> Hi,
>>   is this a known issue? Should I bother to upgrade to 2.6.19.2 if it contains the fix?
>> Thank you any help. It might be related to NFS. The machine in question is NFSv3 client,
>> udp. And used for computations. The process which died is from torque cluster management
>> package.
> 
>> 000: 00 00 00 00 fe ff ff ff fe ff ff ff 3a 00 00 00
> 
> The beginning of the slab was overwritten. The first two words should have 
> been list pointers. color offset is also invalid as is the pointer to the 
> slab memory.
> 
> Are you using cpu hotplug by chance?

No, it is a classical P4 machine, ASUS P4C800E-Deluxe motherboard. However, it might
have been related to the overclocked CPU. Although 12 other, exactly same machines are running
fine at the same over-clock I have decreased the settings. It did not happen since then.
So I believe it was a hardware issue. Thanks for the explanation.
Martin
