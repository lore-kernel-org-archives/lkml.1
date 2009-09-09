Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZIIJm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZIIJm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZIIJm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:42:26 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:37677 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZIIJmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:42:25 -0400
MIME-Version: 1.0
In-Reply-To: <20090909092822.GA18355@electric-eye.fr.zoreil.com>
References: <b2cdc9f30909090013q1741da26la73da66f1eef975f@mail.gmail.com>
	 <20090909092822.GA18355@electric-eye.fr.zoreil.com>
Date: Wed, 9 Sep 2009 10:37:02 +0100
X-Google-Sender-Auth: e45f6a1a9eeedc56
Message-ID: <b2cdc9f30909090237t67e8c478he6f6e92f167d6a2b@mail.gmail.com>
Subject: Re: r8169 ethernet hangs after a pm-suspend (and resume)
From: Alex Bennee <kernel-hacker@bennee.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/9 Francois Romieu <romieu@fr.zoreil.com>:
> Alex Bennee <kernel-hacker@bennee.com> :
> [...]
>> I've just recently gotten suspend working on my system. Unfortunately
>> after the resume event I loose access to the network.
>> As far as the system is concerned the network is configured properly
>> but every attempt to ping local nodes fails with "Host not reachable".
>
> Can the problem be described as "gigabit link setting does not survive
> suspend/resume" ?

How could I check?

AFAIK my network only runs at 100Mbs anyway. I tried poking about with
ethtool to see if could determine any more diagnostics but it didn't know
much about the card.

>
> --
> Ueimor
>



-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
