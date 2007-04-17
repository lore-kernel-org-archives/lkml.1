Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbXDQPQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbXDQPQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXDQPQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:16:10 -0400
Received: from usul.saidi.cx ([204.11.33.34]:59804 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754458AbXDQPQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:16:08 -0400
Message-ID: <4624E4AA.8050408@overt.org>
Date: Tue, 17 Apr 2007 08:15:54 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: linux-kernel@vger.kernel.org
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
In-Reply-To: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
X-Enigmail-Version: 0.93.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-I-Got-Here: Yes
X-I-Got-Here: Yes3
Subject: Re: MMCv4 support (8-bit support missing)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Madhusudhan c wrote:
> Hi Pierre/philip,
> 
> This is regarding the MMCv4 support that came in as part of the MMC
> core of 2.6.20 linux kernel version.
> 
> The high speed MMC cards can support 4-bit/8-bit transfers. The 8-bit
> support seems to be missing from the MMCv4 support implemented by
> Philip Langdale .
> To support 8-bit transfers the core needs to implement "bus testing
> procedure". This requires support for CMD19 and CMD14.
> 
> Why is the support for bus testing procedure msiing from the MMCv4 support?

Because we have not seen any 8-bit hardware - let alone any 8-bit hardware
which we know how to drive. It is unclear how necessary the bus testing sequence
is, but the main reason why it's not there is that I could never get it to work
on the sdhci controller I use for testing. Due to how the CRC is handled for these
commands, the controller gets confused, reports failure, and doesn't provide the
returned data - making the test impossible.

If you have found an 8-bit controller that we can support, we'd love to know about
it!

--phil
