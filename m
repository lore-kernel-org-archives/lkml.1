Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYBYD2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYBYD2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 22:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYBYD2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 22:28:40 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1678 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYBYD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 22:28:39 -0500
Date: Mon, 25 Feb 2008 03:29:44 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Benny Halevy <bhalevy@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
Message-ID: <20080225032944.GA30294@shadowen.org>
References: <20080114232913.2555d392@paolo-desktop> <20080128145605.GI12910@shadowen.org> <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com> <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com> <47C18AAB.7050503@panasas.com> <4d8e3fd30802241014g503c78a2wc08bd1939657802b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30802241014g503c78a2wc08bd1939657802b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 07:14:13PM +0100, Paolo Ciarrocchi wrote:
> On Sun, Feb 24, 2008 at 4:18 PM, Benny Halevy <bhalevy@panasas.com> wrote:
> [...]
> >  How about:
> >  -                               WARN("no space between function name and open parenthesis '('\n" . $herecurr);
> >  +                               WARN("there should be no space between function name and open parenthesis '('\n" . $herecurr);
> 
> I originally suggested:
> +                               WARN("don't put a space between
> function name and open parenthesis '('\n" . $herecurr);
> but I really prefer your version.
> 
> >  The original phrasing can be interpreted like "there is no space between ..." and the correct
> >  interpretation should be "there should be no space between ..."
> 
> Indeed.

As we want the messages to be as short as possible, I am leaning towards
standardising on:

	spaces prohibited <where>
	spaces required <where>

-apw
