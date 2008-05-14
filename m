Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbYENIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbYENIiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757197AbYENIiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:38:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:41938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbYENIh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:37:59 -0400
From: Andreas Schwab <schwab@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
References: <Pine.LNX.4.64.0805140958400.5778@anakin>
X-Yow: What PROGRAM are they watching?
Date: Wed, 14 May 2008 10:37:57 +0200
In-Reply-To: <Pine.LNX.4.64.0805140958400.5778@anakin> (Geert Uytterhoeven's
	message of "Wed, 14 May 2008 10:02:11 +0200 (CEST)")
Message-ID: <jeprrpth5m.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> My first guess is gcc is turning sizeof() into strlen() again.

Definitely not.  sizeof is a compile-time constant, strlen is not.  More
likely the strlen call is embedded in the expansion of strncat.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
