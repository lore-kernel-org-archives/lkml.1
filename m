Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXGXWlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXGXWlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXGXWlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:41:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbXGXWlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:41:15 -0400
Message-ID: <46A68003.6060901@redhat.com>
Date: Tue, 24 Jul 2007 18:41:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de>
In-Reply-To: <20070724220053.GA20531@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2007 06:00 PM, Ulrich Kunitz wrote:
> On 07-07-24 16:57 Chuck Ebbert wrote:
> 
>>> $ strace ./cat
>>> execve("./cat", ["./cat"], [/* 55 vars */]) = -1 ENOENT (No such file or directory)
>>> ...
> 
> Chuck, my binaries run always into a segmentation violation. So
> ENOENT is not the issue. (Notify it was on an x86-64.)
> 

Okay, I tested with Fedora on x86_64 and it worked there too.
(Not that that proves much.)

Did you capture any of the error messages, like the address
of the segfault?

