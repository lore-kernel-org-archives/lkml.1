Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYCITC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYCITC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYCITCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:02:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYCITCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:02:19 -0400
Date: Sun, 9 Mar 2008 12:01:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Dave Young" <hidave.darkstar@gmail.com>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare
 with jiffies
Message-Id: <20080309120133.2d1363e4.akpm@linux-foundation.org>
In-Reply-To: <20080309110808.2249aa3a@core>
References: <200803080735.06984.hidave.darkstar@gmail.com>
	<877igd6vqn.fsf@saeurebad.de>
	<a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	<20080309095802.70d91c7b@core>
	<a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
	<20080309110808.2249aa3a@core>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 11:08:08 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Yes, This has a purpose as well. You will find most of the usage of these
> > macros are just compare some value with jiffies after doing some grep.
> 
> That is no reason to add more macros that hide how they do it, or make
> jiffies itself invisible to the grep search or variable usage finding
> tools (and for tickless that very thing is important)

We could call them time_is_after_jiffies(), time_is_before_jiffies(), etc.

Those names are actually better than time_after_now(), etc.

