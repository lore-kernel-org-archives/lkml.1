Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbXGPWLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbXGPWLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXGPWK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:10:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35555
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759965AbXGPWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:10:58 -0400
Date: Mon, 16 Jul 2007 15:00:57 -0700 (PDT)
Message-Id: <20070716.150057.59832795.davem@davemloft.net>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ak@suse.de
Subject: Re: powerd in arch/sparc64/kernel/power.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <469BC777.5010207@goop.org>
References: <469BC777.5010207@goop.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 16 Jul 2007 12:31:03 -0700

> Hi Dave,
> 
> I was about to submit the patch below for merging, but it obviously 
> conflicts with your change 13077d80286205e02eebe1c2786a914a4bbd2588 
> ("[SPARC64]: Export powerd facilities for external entities.") which was 
> merged this morning.
> 
> My patch makes orderly_poweroff() a globally-common function to generate 
> a user-level poweroff event, and it basically a superset of powerd.   
> Should I drop the sparc parts of this patch, or would you be OK with 
> dropping powerd?

Put the generic code in and I'll try to make use of it in sparc64.
I have two spots that need it now.
