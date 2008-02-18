Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYBRC30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYBRC30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYBRC3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:29:17 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40827 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYBRC3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:29:16 -0500
Message-ID: <47B8EDDA.4080801@keyaccess.nl>
Date: Mon, 18 Feb 2008 03:30:50 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: fix init_8259A() to not use outb_pic
References: <6gr00g$g7cm8h@smtp01.lnh.mail.rcn.net> <20080217222552.1af463b4@core>
In-Reply-To: <20080217222552.1af463b4@core>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-02-08 23:25, Alan Cox wrote:

> On Sun, 17 Feb 2008 16:56:28 -0500 (EST)
> "David P. Reed" <dpreed@reed.com> wrote:
> 
>> fix init_8259A() which initializes the 8259 PIC to not use outb_pic,
>> which is a renamed version of outb_p, and delete outb_pic define.
> 
> NAK
> 
> The entire point of inb_pic/outb_pic is to isolate the various methods
> and keep the logic for delays in one place. Undoing this just creates a
> nasty mess.
> 
> Quite probably inb_pic/outb_pic will end up as static inlines that do inb
> or outb with a udelay of 1 or 2 but that is where the knowledge belongs.

Additional NAK in sofar that the PIC delays were reported to be necesary 
with some VIA chipsets earlier in these threads.

Rene.
