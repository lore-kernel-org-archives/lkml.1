Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXFPHKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXFPHKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbXFPHKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:10:15 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:57094 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXFPHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:10:13 -0400
Message-ID: <46738CD2.2080804@dgreaves.com>
Date: Sat, 16 Jun 2007 08:10:10 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Michael Gerdau <mgd@technosis.de>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>	<200706142049.41819.dhazelton@enter.net>	<200706150825.15491.mgd@technosis.de>	<200706150520.15086.dhazelton@enter.net>	<46726793.1020206@dgreaves.com>	<alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>	<4672D648.7020700@dgreaves.com> <m37iq496z9.fsf@maximus.localdomain>
In-Reply-To: <m37iq496z9.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> David Greaves <david@dgreaves.com> writes:
> 
>> This 5 minute design undoubtedly has flaws but it shows a direction:
>> A basically standard 'De11' PC with some flash.
>> A Tivoised boot system so only signed kernels boot.
>> A modified kernel that only runs (FOSS) executables whose signed hash
>> lives in the flash.
> 
> How hard would it be to reprogramm the flash?

The flash contains hashes signed by the companies private key.

The kernel contains the public key. It can decrypt the hashes but the private 
key isn't available to encrypt them. So although you can put a new application 
onto the system, you can't create a signed hash to write to the flash.

The kernel only runs the executable if the hash is valid.
You can re-write the kernel to avoid this check - but the hardware is Tivoised - 
so you can't run it.

I am not suggesting the kernel should go down the GPLV2 route - I am wondering 
if this is a viable scenario or one of Schneiers'  "movie-plot" threats :)

David

