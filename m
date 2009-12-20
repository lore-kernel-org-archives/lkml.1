Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZLTCpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZLTCpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 21:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZLTCpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 21:45:11 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:51674 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZLTCpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 21:45:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vkAaZqg0dfxBbxInZGJBQsnQKAQQMbynagEuzg7UyzCT02n045GxjoQ8Mq2S74aPhS
         /dEyPOxp4Dd6ZLblD4s9zFZbxNGeFawXerMAQdQN3X6L6hM6jUS9Tup0kmhBT7veOLjI
         jbmZujQFAIvAOSuBFM4sZ/p5uWrrv6GcxqMcs=
Date: Sat, 19 Dec 2009 18:45:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
	suspend-resume patch w/ rwsems)
Message-ID: <20091220024503.GD4073@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912200040.18944.rjw@sisk.pl> <alpine.LFD.2.00.0912191542570.3712@localhost.localdomain> <200912200053.45988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912200053.45988.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 12:53:45AM +0100, Rafael J. Wysocki wrote:
> On Sunday 20 December 2009, Linus Torvalds wrote:
> > 
> > If it isn't, don't do that then. But we actually have no real 
> > reason to believe that it would be problematic, at least on a PC where the 
> > actual logic is on the SB (presumably behind the LPC controller).
> > 
> > Why would it be?
> 
> The embedded controller may depend on it.
>

No, not really depend but rather wierd things may happen if you
accessing both. Witness regressions where touching embedded controller
makes us lose data from touchpad, I think you are CCed on that bug.

-- 
Dmitry
