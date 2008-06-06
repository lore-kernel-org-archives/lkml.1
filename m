Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbYFFFY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbYFFFY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 01:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYFFFYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 01:24:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbYFFFYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 01:24:46 -0400
Date: Thu, 5 Jun 2008 22:23:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: pppd and 2.6.25 serial driver
Message-Id: <20080605222355.be299fff.akpm@linux-foundation.org>
In-Reply-To: <20080601215621.256db193@boulder.homenet>
References: <20080601215621.256db193@boulder.homenet>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 21:56:21 +0100 Chris Vine <chris@cvine.freeserve.co.uk> wrote:

> Because I have had to resort to using dial-up this weekend, I noticed
> that the serial driver for the 8250/16550 UART in the 2.6.25 kernel does
> not work correctly with ppp-2.4.4. After establishing a dial-up modem
> connection it becomes unresponsive and pppd will exit waiting to
> establish a ppp connection after sending LCP configuration requests.  I
> have tested this with two different dial-up modems and at two different
> dial-up providers, with the 2.6.25.3 and 2.6.25.4 kernels.
> 
> pppd works fine with the 2.6.25 kernel if the serial driver is not used
> (for example if establishing a ppp connection over (in kernel) ATM or
> via an (out of kernel tree) softmodem driver I have.
> 
> The serial driver in 2.6.24.7 works correctly, and the good news is
> that 2.6.26-rc2 also works fine.
> 

Fun.  Presumably that means there's some serial fix which we forgot
to backport.  Or it isn't in 2.6.25.x yet.

