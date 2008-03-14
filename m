Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYCNJVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYCNJVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCNJVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:21:31 -0400
Received: from styx.suse.cz ([82.119.242.94]:34073 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752306AbYCNJVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:21:30 -0400
Date: Fri, 14 Mar 2008 10:21:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: David Newall <davidn@davidnewall.com>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
In-Reply-To: <20080313171425.GA4840@ucw.cz>
Message-ID: <Pine.LNX.4.64.0803141020380.30831@jikos.suse.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
 <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com>
 <20080313171425.GA4840@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Pavel Machek wrote:

> No.
> hw is proper place to implement autorepeat, and along with some 
> buffering, it has chance to work. Kernel is not real-time, and X are 
> definitely not real-time, while autorepeat is real-time operation.
> It actually mostly works in ps/2 case. Buffer in hardware means that 
> pretty big interrupt delays can be tolerated without problems.

That's true. Unfortunately USB keyboards don't behave this way and there 
is nothing we can do about that.

-- 
Jiri Kosina
SUSE Labs
