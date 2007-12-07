Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXLGOyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXLGOyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXLGOyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:54:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53919 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbXLGOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:54:33 -0500
Date: Fri, 7 Dec 2007 15:54:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "David P. Reed" <dpreed@reed.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071207145430.GA5992@one.firstfloor.org>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <47595DB2.5080302@reed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47595DB2.5080302@reed.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My machine in question, for example, needs no waiting within CMOS_READs 
> at all.   And I doubt any other chip/device needs waiting that isn't 

I don't know about CMOS, but there were definitely some not too ancient
systems (let's say not more than 10 years) who required IO delays in the
floppy driver and the 8253/8259. But on those the jumps are already
far too fast.

-Andi
