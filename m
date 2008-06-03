Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYFCTo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYFCTo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYFCToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:44:00 -0400
Received: from keil-draco.com ([216.193.185.50]:34066 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbYFCTn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:43:59 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Date: Tue, 3 Jun 2008 15:43:56 -0400
User-Agent: KMail/1.9.9
Cc: Jeff Dike <jdike@addtoit.com>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, nix@esperi.org.uk
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603123211.e129c222.akpm@linux-foundation.org>
In-Reply-To: <20080603123211.e129c222.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031543.56864.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 03:32:11 pm Andrew Morton wrote:
> On Tue, 3 Jun 2008 15:02:35 -0400
>
> Jeff Dike <jdike@addtoit.com> wrote:
> > Protection against the host's time going backwards - keep track of the
> > time at the last tick and if it's greater than the current time, keep
> > time stopped until the host catches up.
>
> Strange.  What would cause the host's time (or at least UML's perception
> of it) to go backwards?

A wild guess would be that the UML process is running "fast" at some point and 
its expectation of the host's time is skewed forward because of that.

Another possibility is that the hosts clock got reset between the times UML 
has checked it and the correction was a negative one.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
