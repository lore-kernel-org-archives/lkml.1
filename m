Return-Path: <linux-kernel-owner+w=401wt.eu-S1764488AbXJEVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764488AbXJEVN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763366AbXJEVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:13:10 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:64370 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763034AbXJEVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:13:09 -0400
Date: Fri, 5 Oct 2007 23:13:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Various problems on Axis 700 Lite VIA C7
Message-ID: <20071005231306.447e91f8@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.60.0710052215510.10392@poirot.grange>
References: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
	<Pine.LNX.4.60.0710052215510.10392@poirot.grange>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Fri, 5 Oct 2007 22:22:08 +0200 (CEST), Guennadi Liakhovetski wrote:
> Ok, after a day of biseting, it turns out to be a compiler problem. The 
> gcc-3.3.5 produces at least these two problems (Oops on i2c-viapro probe 
> and disabled IRQs in USB), whereas 4.1.2 has no problem so far. Up to now 
> 3.3.5 had no problem compiling 2.6.20+ kernels here, for example, for P-II 
> SMP. Does it at all look realistic that such "random" run-time problems 
> are caused by a miscompilation?...

Miscompilation can do about anything. There have been a number of other
reports about compiler issues lately. Ingo Molnar here:
http://kerneltrap.org/Linux/Compiler_Optimization_Bugs_and_World_Domination
Me here:
http://marc.info/?l=linux-kernel&m=119127234804440&w=2

The trend I am seeing is that we are optimizing for, and testing with,
recent compilers (gcc 4.1 and later) and that older compilers tend to
break, even though compilers as old as gcc 3.2 are still supposed to be
supported. Not good.

-- 
Jean Delvare
