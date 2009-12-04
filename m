Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZLDRt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZLDRt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbZLDRty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:49:54 -0500
Received: from elvis.franken.de ([193.175.24.41]:45156 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbZLDRty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:49:54 -0500
X-Greylist: delayed 6366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 12:49:53 EST
Date: Fri, 4 Dec 2009 17:03:33 +0100
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: myuboot@fastmail.fm
Cc: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: Re: PIR OFFSET for AR7
Message-ID: <20091204160333.GA8842@alpha.franken.de>
References: <20091028103551.0b4052d8@pixies.home.jungo.com> <1259891550.19943.1348372917@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259891550.19943.1348372917@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 07:52:30PM -0600, myuboot@fastmail.fm wrote:
> Hi, What is the use of PIR register for AR7 board in file
> arch/mips/ar7/irq.c?

it gives back the channel and line of the pending interrupt with the
highest priority.

> If I understand it right, PIR is used to define the
> polarity of the interrupts. It seems to me that it needs to initialized?

no, it's a read only register. Why do you think it has something to do
with interrupt polarity ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
