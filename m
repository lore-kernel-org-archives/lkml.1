Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYGKTtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYGKTtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYGKTtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:49:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37352 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYGKTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:49:21 -0400
Date: Fri, 11 Jul 2008 21:50:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       "Joe Burks (jburks"@wavicle.org,
       "Christopher L Cheney (ccheney"@cheney.cx,
       "Pavel Machek (pavel"@suse.cz, "John Tyner (jtyner"@cs.ucr.edu,
       "Monroe Williams (monroe"@pobox.com
Subject: Re: [PATCH] vicam: use request_firmware()
Message-ID: <20080711195002.GA7190@elf.ucw.cz>
References: <1214583311.29137.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214583311.29137.4.camel@jaswinder.satnam>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-06-27 21:45:11, Jaswinder Singh wrote:
> ???We use the Intel HEX record format for this firmware, because it's split
> into separate chunks and that's the simplest way to handle them in a
> single firmware file -- the alternative would be loading each part as
> a separate file.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Actually, this is going to make suspend/resume support for vicam hard
:-(. 

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
