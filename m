Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYHTHZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYHTHZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYHTHZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:25:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbYHTHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:25:12 -0400
Date: Wed, 20 Aug 2008 00:25:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Peters <frank.peters@comcast.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.26 Breaks USB Fax Modem
Message-Id: <20080820002508.069a6a84.akpm@linux-foundation.org>
In-Reply-To: <20080819211039.a273679f.frank.peters@comcast.net>
References: <20080819211039.a273679f.frank.peters@comcast.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 21:10:39 -0400 Frank Peters <frank.peters@comcast.net> wrote:

> Hello,
> 
> After updating the kernel from 2.6.25 to 2.6.26, I now experience
> severe problems when trying to send a fax using an external USB
> modem.  Using either HylaFAX or efax facsimile software, the fax
> transmission will just suddenly hang at some point before completion.
> Neither the fax log or the kernel log will show any error or other
> anomaly.  Rebooting the system with kernel 2.6.25 will allow me
> to send faxes without problem.
> 
> Nothing on my machine has changed between 2.6.25 and 2.6.26 and
> the same configuration was used to compile both versions. 
> 
> The cdc-acm module is responsible for communicating with the USB
> modem and I suspect that it is at fault.
> 
> Has this problem been reported by anyone else?  How can I further
> debug this problem?  As I mentioned, no log shows any error message
> of any kind.  The logs from the fax software may indicate an
> "unspecified error" but will usually just show that the data
> stream has been abruptly halted.
> 
> Please cc to me directly since I am not subscribed to the list.
> 

(cc linux-usb)

Are any processes left hanging in `D' state afterwards?

If so, please run

	echo w > /proc/sysrq-trigger
	dmesg -s 1000000 > foo

then send foo.

Thanks.
