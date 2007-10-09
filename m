Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXJIOWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXJIOWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXJIOWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:22:15 -0400
Received: from sumo.dreamhost.com ([66.33.216.29]:47730 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbXJIOWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:22:15 -0400
Date: Tue, 9 Oct 2007 10:19:16 -0400
From: Gustavo Chain <g@0xff.cl>
To: linux-kernel@vger.kernel.org
Subject: Re: howto boost write(2) performance?
Message-ID: <20071009101916.5a7f5c19@0xff.cl>
In-Reply-To: <1191937817.3641.9.camel@blackberry>
References: <1191937817.3641.9.camel@blackberry>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 09 Oct 2007 15:50:17 +0200
Michael Stiller <ms@2scale.net> escribió:

> Hi list,
> 
> i'm developing an application (in C) which needs to write about 
> 1Gbit/s (125Mb/s) to a disk array attached via U320 SCSI. 
> It runs on Dual Core 2 Xeons @2Ghz utilizing kernel 2.6.22.7. 
> 
> I buffer the data in (currently 4) 400Mb buffers and use write(2) in a
> dedicated thread to write them to the raw disk (no fs). 
> 
> The write(2) performance is not good enough, the writer threads take
> to much time, and i ask you for ideas, howto to boost the write
> performance. 
> 
> Maybe mmaping the disk would work? 
> 
> Cheers,
> 
> -Michael
> 
> PS. I would like to be cc'd as i usually don't read the list due to
> high traffic.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Create a 1GB ram disk, write data there, and then backup into a hard
disk

-- 
Gustavo Chaín Dumit
