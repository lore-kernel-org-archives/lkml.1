Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZFCV3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZFCV3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZFCV3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:29:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZFCV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:29:04 -0400
Message-ID: <4A26EB18.6060907@zytor.com>
Date: Wed, 03 Jun 2009 14:28:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexey Vlasov <renton@renton.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru>
In-Reply-To: <20090603142801.GC21646@beaver.vrungel.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Vlasov wrote:
> Hi.
> 
> In comparison with bind/proc mounting it takes a lot more time mounting
> devpts. Is it possible to somehow accelerate the process? Now there are
> about 5k devpts mounting, it already took 20 minutes, further will take
> even more time.
> 
> # time mount -n -i -t devpts none /home/staff/.server-1/dev/pts
> real    0m0.295s
> user    0m0.000s
> sys     0m0.288s
> 

A profile would be handy here.  There is no sensible reason for this to
that 0.3 seconds.  This might be RCU-epoch related?

	-hpa

