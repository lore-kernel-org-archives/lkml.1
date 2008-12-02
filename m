Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYLBQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYLBQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYLBQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:30:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYLBQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:30:54 -0500
Message-ID: <493562A5.40308@zytor.com>
Date: Tue, 02 Dec 2008 08:30:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: Re: SD/MMC cards: how crappy they are?
References: <20081202144830.GB1549@ucw.cz>
In-Reply-To: <20081202144830.GB1549@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> ...maybe it was because of powerfail? I'll try to run badblocks to
> recover it...
> 
> ...I did. Badblocks did not help, but cat /dev/zero > /dev/mmc1
> did.. And yes, thosse 'temporarily bad blocks' seem very much
> powerfail related.
> 

Power failures can, indeed, do nasty things to SD/MMC cards, especially
power rail sag in the middle of writes.

	-hpa
