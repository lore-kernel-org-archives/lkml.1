Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYAWEJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYAWEJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYAWEJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:09:40 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:52757 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYAWEJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:09:39 -0500
Date: Tue, 22 Jan 2008 22:09:37 -0600
From: David Fries <david@fries.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
Message-ID: <20080123040937.GB4025@spacedout.fries.net>
References: <20080121231557.GA4025@spacedout.fries.net> <479541F5.9080705@zytor.com> <47955ECB.3050100@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47955ECB.3050100@zytor.com>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Tue, 22 Jan 2008 22:09:38 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 07:11:07PM -0800, H. Peter Anvin wrote:
> H. Peter Anvin wrote:
> >Millikelvins would have the nice property of never being negative.  :)

True, but the sensor returns the value as a signed integer in C.  That
is where the earlier negative number problem was, it would have to do
yet another conversion to go to Kelvin, and it would be just one more
potential for error.  Everyone knows that a bad conversion doomed at
least one space craft, let's stick to Centigrade.

> Alternatively, centikelvins would fit nicely in 16 bits if anyone cares...
> 
> 655.35 K = 382.20 ?C = 719.96 ?F

The range for the sensor is -55 to 125 C, if an application didn't
care about precision they could store it in a signed 8 bit value just
fine.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
