Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYKQVPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYKQVPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYKQVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:15:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:47150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYKQVPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:15:04 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Victoria Muntean" <vikimun@gmail.com>
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: Re: size of swapped-out part of the process
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
	<ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
	<Pine.LNX.4.64.0811171343340.11044@blonde.site>
	<ab4346860811171142je64d197keeb984bf7299e951@mail.gmail.com>
X-Yow: I was making donuts and now I'm on a bus!
Date: Mon, 17 Nov 2008 22:14:57 +0100
In-Reply-To: <ab4346860811171142je64d197keeb984bf7299e951@mail.gmail.com>
	(Victoria Muntean's message of "Mon, 17 Nov 2008 21:42:09 +0200")
Message-ID: <jeej1acawe.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Victoria Muntean" <vikimun@gmail.com> writes:

> Can you possibly explain what types of pages create  "VSZ>>RSZ"
> effect in total absence of swapping and plenty of free memory ?

Any mapping that hasn't been touched yet.  A page that is never read nor
written will never become resident.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
