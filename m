Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYANLMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYANLMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYANLME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:12:04 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:44525 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYANLMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:12:01 -0500
Date: Mon, 14 Jan 2008 13:11:58 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080114111158.GB29126@jolt.modeemi.cs.tut.fi>
References: <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <1200303743.24517.6.camel@tara.firmix.at> <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi> <1200304629.24517.15.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1200304629.24517.15.camel@tara.firmix.at>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-14 10:57 +0100, Bernd Petrovitsch wrote:
> That leads to the question why the clock starts to run like crazy at
> some time so that `ntpd` can't cope with it.

I do wonder whether the PSU could've been causing it. Now that think
about it, I got the PSU around two years ago, just like I compiled 
2.6.14. This PSU coincidentally seems to have been the cause of the 
crash that started this thread, and went completely silent during 
the same day, on the third crash. But even if the PSU could cause
the timer interrupt to signal too frequently or so, doesn't explain
why nearly always after a crash (when journal recovery would be the
normal course of action), fsck starts checking with absurd intervals
since last check, whereas there's no trouble booting after normal
shutdown.

-- 
Tuomo
