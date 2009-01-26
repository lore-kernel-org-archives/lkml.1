Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZAZH2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZAZH2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 02:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZAZH2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 02:28:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbZAZH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 02:27:59 -0500
Date: Sun, 25 Jan 2009 23:27:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas Tuttle" <linux-kernel@ttuttle.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: System hang (and other problems) with cdc_acm
Message-Id: <20090125232753.db40c160.akpm@linux-foundation.org>
In-Reply-To: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com>
References: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb)

On Mon, 19 Jan 2009 15:20:13 -0500 "Thomas Tuttle" <linux-kernel@ttuttle.net> wrote:

> Hi.
> 
> I've got a Lenovo X200 with an Ericsson F3507g Mobile Broadband Module
> (a 3G cellular data card with built-in GPS), which uses the cdc_acm
> driver.  I've experienced a couple of problems with it.  First, it
> tends to hang the system after I've been using it for a while.  This
> occurs whenever it's sending a lot of data to/from the computer,
> whether it's a PPP connection or a GPS data stream.  I'm not sure how
> to debug this; the Caps Lock light isn't flashing, so I'm not sure if
> it's a panic or just a hang.  Second, if I read one of the TTYs using
> "cat", I get a ton of blank lines.  To make any sense of the data
> stream, I have to do cat /dev/ttyACM0 | grep -v "^$".
> 
> If anyone could help me debug this, I'd be greatly appreciative.
> 
> Thanks,
> 
> Thomas Tuttle
