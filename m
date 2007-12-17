Return-Path: <linux-kernel-owner+w=401wt.eu-S936766AbXLQUn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936766AbXLQUn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935336AbXLQUnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:43:41 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:39899 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935095AbXLQUnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:43:39 -0500
Date: Mon, 17 Dec 2007 21:43:28 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: swapping in 2.6.24-rc5-git3
Message-ID: <20071217204328.GE14091@ics.muni.cz>
References: <20071217131726.GA14091@ics.muni.cz> <20071217171532.GK6979@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071217171532.GK6979@atrey.karlin.mff.cuni.cz>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 17 Dec 2007 21:43:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 06:15:32PM +0100, Jan Kara wrote:
>   Yes, that's quite unpleasant. How much memory do you have? If you have
> some time, you can try playing with the code in mm/vmscan.c to find out
> what's happening in your case (putting some debugging output in
> shrink_active_list() etc...

I think it is a regression in recent rc versions as I use 2.6.24-xx kernels on
my new laptop from the very beginnig I have the laptopt and I did not notice
such behaviour before.

I have 1 GB RAM and I was coping a 2GB file from the network to the laptop.
After the operation, 600MB of the swap area has been consumed. At the
beginning of the copy, the swap area was empty.

-- 
Luká¹ Hejtmánek
