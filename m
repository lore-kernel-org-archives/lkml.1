Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbYF3UwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbYF3UwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYF3UwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:52:18 -0400
Received: from vena.lwn.net ([206.168.112.25]:48306 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYF3UwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:52:17 -0400
Date: Mon, 30 Jun 2008 14:52:15 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Pan, Weimin" <weimin.pan@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Why  get_user_pages fails?
Message-ID: <20080630145215.7953b78b@bike.lwn.net>
In-Reply-To: <6B24EEDBA38D764293B27C04FE414CC64E4091DF15@G1W0491.americas.hpqcorp.net>
References: <6B24EEDBA38D764293B27C04FE414CC64E4091DE4E@G1W0491.americas.hpqcorp.net>
	<20080630135139.2b53c93d@bike.lwn.net>
	<6B24EEDBA38D764293B27C04FE414CC64E4091DF15@G1W0491.americas.hpqcorp.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 20:45:47 +0000
"Pan, Weimin" <weimin.pan@hp.com> wrote:

> Do I have a way to map a range of phy memory to user virtual address
> and have the page structures built for that memory region? I know
> remap_pfn_range() doesn't work.

The question is: why are you taking this memory out of the kernel's
view in the first place?  You're telling the kernel not to manage that
memory, and it's listening to you - but you shouldn't then complain that
it's not managing that memory.

Again, if you would post your code, others would be in a better
position to help you.

jon
