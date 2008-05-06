Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYEFLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYEFLUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYEFLUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:20:31 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:48895 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYEFLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:20:30 -0400
Date: Tue, 6 May 2008 13:20:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jan Kara <jack@suse.cz>
cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Problem mounting ext2 using ext3?
In-Reply-To: <20080506100216.GB1409@duck.suse.cz>
Message-ID: <Pine.LNX.4.64.0805061319390.10091@anakin>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu>
 <20080506100216.GB1409@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Jan Kara wrote:
>   Thanks Ted for looking into this. Yes, the problem is caused by my
> modifications to quota code... The patch below fixes it for me and I've
> also added a comment so that someone does not remove the check again in
> future ;).

I'll try to give it a try this evening...

> +	 * Skip everything if there's nothing to do. We have to do this becase
                                                                        ^^^^^^
									because

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
