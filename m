Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbXIQStL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbXIQStL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXIQSs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:48:56 -0400
Received: from gw.goop.org ([64.81.55.164]:44966 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbXIQSsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:48:54 -0400
Message-ID: <46EECC16.10501@goop.org>
Date: Mon, 17 Sep 2007 11:48:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions
References: <20070917175139.GA4941@gollum.tnic> <46EEC418.6070005@goop.org> <20070917183346.GA9006@gollum.tnic>
In-Reply-To: <20070917183346.GA9006@gollum.tnic>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> That is more compact, I agree. However, the XXBIT_MASK macros have the
> better readability, imho. And also, doing 
>
> $grep -Prin 'DMA_..BIT_MASK' * | wc -l
>
> returns 383 on the 23-rc6 tree so removing them should be quite the logistical
> challenge for the kernel janitors :). What do the others think?
>   

Well, even defining the existing macros in terms of DMA_BIT_MASK would
be an improvement.  It's certainly not obvious at first glance that
0x00000007ffffffffULL is a correct 35-bit mask - it's something that the
compiler is perfectly happy to compute for us.

    J
