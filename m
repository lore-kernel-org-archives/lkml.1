Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYLBSAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYLBSAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYLBSAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:00:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYLBSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:00:10 -0500
Message-ID: <4935778E.1020405@zytor.com>
Date: Tue, 02 Dec 2008 09:59:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu>
In-Reply-To: <20081202165608.GD18162@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> If this is your random eject out from your HP laptop problem, note
> that random ejects while the card is writing can cause corruption of
> the flash translation layer (FTL), which for some really crappy cards,
> can permanently damage them; hopefully most of those are gone from the
> market, but I wouldn't be positive about that.  The better ones will
> have some kind of journalling scheme for their FTL...
> 

I have seen flash cards die permanently from having a partition table it
didn't like written to it.  Yes, the microcontroller on the flash card
tried to interpret the partition table, assumed to be MS-DOS style, and
would crash.

	-hpa
