Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZD0Sle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZD0Sle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbZD0SlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:41:05 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53865 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZD0SlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:41:04 -0400
Date: Mon, 27 Apr 2009 20:43:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 3/8] arm: Use __INIT macro instead of .text.init.
Message-ID: <20090427184313.GC12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-4-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:22PM -0400, Tim Abbott wrote:
> arm is placing some code in the .text.init section, but it does not
> reference that section in its linker scripts.
> 
> This change moves this code from the .text.init section to the
> .init.text section, which is presumably where it belongs.

It looks obviously correct.
But I tried and failed to follow the chain of usage.

So we need an ack from Russell on this one.

	Sam
