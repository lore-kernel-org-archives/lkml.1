Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYIIKuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYIIKuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYIIKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:50:04 -0400
Received: from www.tglx.de ([62.245.132.106]:54021 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYIIKuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:50:04 -0400
Date: Tue, 9 Sep 2008 12:49:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [regression] __tick_program_event of hpet is stuck
In-Reply-To: <200809080313.48910.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809091248590.3271@apollo.tec.linutronix.de>
References: <200809080114.36106.elendil@planet.nl> <200809080313.48910.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Frans Pop wrote:

> On Monday 08 September 2008, Frans Pop wrote:
> > With current git head (v2.6.27-rc5-319-g7686ad5) I'm seeing repeated
> > occurrences of the following on my HP Compaq 2510p laptop. Not seen
> > with earlier kernels, including 2.6.27-rc5.
> 
> I meant repeated as in "after different boots", but I now also see repeats 
> when I leave the system on for some time. It keeps increasing the 
> min_delta_ns to ever higher values.
> 
> CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
> CE: increasing min_delta_ns 5000 to 10000 nsec
> [...]
> CE: __tick_program_event of hpet is stuck 33576032f74 33576035684
> CE: increasing min_delta_ns 10000 to 20000 nsec
> [...]
> CE: __tick_program_event of hpet is stuck 63242b30d28 63242b35b48
> CE: increasing min_delta_ns 20000 to 40000 nsec

Frans,

what's the highest value which you have seen ?

Thanks,

	tglx
