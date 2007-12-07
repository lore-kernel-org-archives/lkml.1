Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXLGPox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXLGPox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 10:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXLGPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 10:44:46 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:36703 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbXLGPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 10:44:45 -0500
Message-ID: <47596A2E.4060602@keyaccess.nl>
Date: Fri, 07 Dec 2007 16:43:42 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <47595DB2.5080302@reed.com> <20071207145430.GA5992@one.firstfloor.org>
In-Reply-To: <20071207145430.GA5992@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-12-07 15:54, Andi Kleen wrote:

>> My machine in question, for example, needs no waiting within CMOS_READs 
>> at all.   And I doubt any other chip/device needs waiting that isn't 
> 
> I don't know about CMOS, but there were definitely some not too ancient
> systems (let's say not more than 10 years) who required IO delays in the
> floppy driver and the 8253/8259. But on those the jumps are already
> far too fast.

Also see Alan's replies in the thread I posted a link to:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-09/5700.html

Also 8254 (PIT) at least it seems.

Rene.
