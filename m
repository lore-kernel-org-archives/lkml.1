Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYGaWGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYGaWGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbYGaWF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:05:58 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:32900 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbYGaWF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:05:58 -0400
Date: Fri, 1 Aug 2008 00:05:19 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc1 process time accounting
Message-ID: <20080731220519.GB5543@ics.muni.cz>
References: <20080731104319.GB5806@ics.muni.cz> <20080731144147.82fcd85e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080731144147.82fcd85e.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 01 Aug 2008 00:05:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 02:41:47PM -0700, Andrew Morton wrote:
> > kthreadd and console-kit-daemons claim they spent 5124095 hours using CPU.
> 
> My 2.6.27-rc1-mm1 kthreadd looks OK in `top'.  How are you displaying
> this information?  More details if possible, please..

ps aux  | grep kthread
root         2 151451100  0.0 0     0 ?        S<   09:49 21114580:11 [kthreadd]

top:
2489 root      20   0  102m 3300 1608 S  0.0  0.2  5124095h console-kit-dae
2 root      15  -5     0    0    0 S  0.0  0.0  5124095h kthreadd

-- 
Luká¹ Hejtmánek
