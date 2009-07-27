Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZG0Neh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZG0Neh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZG0Neh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:34:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:52257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZG0Neg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:34:36 -0400
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Rosenboom <jens@mcbone.net>
Cc: Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248698755.7279.47.camel@fnki-nb00130>
References: <1248681637.7279.12.camel@fnki-nb00130>
	 <1248694266.6987.1594.camel@twins>  <1248697004.7279.31.camel@fnki-nb00130>
	 <1248697409.6987.1617.camel@twins>  <1248698755.7279.47.camel@fnki-nb00130>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 15:36:52 +0200
Message-Id: <1248701812.6987.1637.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 14:45 +0200, Jens Rosenboom wrote:

> Good question, but as this happens on a production machine, I cannot
> easily change the installation to check this.

Uhm, but you do run .31-rc4 on it? :-)

> Attaching an strace to the process gives just
> 
> # strace -p 12886
> Process 12886 attached - interrupt to quit
> 
> and nothing further.

Bugger.. how easy it is to reproduce?
