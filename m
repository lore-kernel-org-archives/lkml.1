Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYKHRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYKHRqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 12:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYKHRqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 12:46:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:52036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYKHRqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 12:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=rUlDjvW/3pbAMzuD92zvExGPoMrzN/Hgf++vt+R1r9UHycQlk5Z0H9tmet//iWDRdZ
         Crwi2+9RxHAmqTtwB9xm3k+YfX77a9id38b9SsbM9J6pCtF14BwP+/rNpWw2JgPZr0S5
         dSRTEZ7ODUTfZ3nqe2vwwIs1QmRAZEC1bPnoc=
Date: Sat, 8 Nov 2008 18:46:25 +0100
From: dcg <diegocalleja@gmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: swappiness in 2.6.28-rc3?
Message-ID: <20081108184625.6a64a518@diego-desktop>
In-Reply-To: <200811081211.24000.gene.heskett@gmail.com>
References: <200811081211.24000.gene.heskett@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 08 Nov 2008 12:11:23 -0500, Gene Heskett <gene.heskett@gmail.com> escribió:

> Greetings;
> 
> I have 2.6.28-rc3 with a 5 day uptime, and I have had to do a "swapoff -a; 
> swapon -a" almost daily to clear the swap.
> 
> This is about 18 hours since I last did that:
> Mem:   4151132k total,  2891180k used,  1259952k free,   281224k buffers
> Swap:  2048276k total,    85864k used,  1962412k free,  2078404k cached
> 
> I don't recall having to do this with 2.6.27 or any of its -rc's.

I've also noticed more swappiness (very probably due to the vm scanning
rework), but I can't say for sure if it's a bad thing...
