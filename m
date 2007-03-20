Return-Path: <linux-kernel-owner+w=401wt.eu-S933296AbXCTJgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296AbXCTJgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXCTJgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:36:49 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37651 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbXCTJgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:36:48 -0400
Date: Tue, 20 Mar 2007 10:38:34 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re: ex-upload
Message-ID: <20070320093834.GO22880@mail.muni.cz>
References: <20070318015323.GH12382@kraken.fi.muni.cz> <20070319135100.GH22880@mail.muni.cz> <20070319151643.GC23780@kraken.fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEEACGAC.davids@webmaster.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Mar 2007 10:36:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>> How can I put delay between subsequent msg sends to achieve desired
>> packet rate without loses, e.g., 3.5Gbps without bursts? Even nanosleep()
>> with the lowest possible delay seems to be too much delay. Busy loop with
>> clock_gettime(3) works OK on SMP boxes, but on UP it causes problems.
>
> Why do you want to avoid bursts? You're going to be bursting between 10Gb/s
> and 0 anyway.

It is because bursts above 5.5Gbps cannot be received by the peer. The peer is
only able to receive bursts up to 5.5Gbps whereas the sender is able to burst
up to 9.9Gbps.

> It sounds like you're deliberately putting impossible requirements on
> yourself choosing the worst possible protocol and demanding the pacing be
> perfect. I don't think the technology to do that is here yet, but why would
> you possibly need it?

it is video transmission encapsulated in RTP over UDP. I do not know whether
there are any other possibilities that would work also on Mac OS or FreeBSD.

(Please Cc me)

-- 
Luká¹ Hejtmánek
