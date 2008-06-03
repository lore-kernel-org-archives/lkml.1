Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbYFCQIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbYFCQIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYFCQH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:07:58 -0400
Received: from panic.printk.net ([217.147.83.20]:46165 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYFCQH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:07:58 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 12:07:58 EDT
Subject: Re: [PATCH 4/7] disable broadcomm legacy boot interrupt generation
From: Jon Masters <jonathan@jonmasters.org>
To: Olaf Dabrunz <od@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Stefan Assmann <sassmann@suse.de>
In-Reply-To: <20080603155914.GC16200@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
	 <12124107072891-git-send-email-od@suse.de>
	 <1212508003.22357.8.camel@londonpacket.bos.redhat.com>
	 <20080603155914.GC16200@suse.de>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 12:05:43 -0400
Message-Id: <1212509143.22357.23.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 17:59 +0200, Olaf Dabrunz wrote:
> On 03-Jun-08, Jon Masters wrote:
> > On Mon, 2008-06-02 at 14:45 +0200, Olaf Dabrunz wrote:
> > 
> > > Add a quirk to disable legacy boot interrupt generation on broadcomm HT1000.
> > 
> > This one interests me, because I got access to the Broadcom HT-1000
> > datasheet and could not find this feature mentioned in there. I'd
> > appreciate knowing how you figured this one out :)
> 
> I had a sharp look at it... ;)

Me too. It's ***NOT*** mentioned in there :)

> Actually, I looked through the datasheet three times, and did not find
> anything. Then I looked at the IRQ routing picture until I had an idea
> of how it is supposed to work and the solution was becoming clear. The
> register descriptions made me believe it could work, and testing
> confirmed this.

Oh, ok, now that takes some inordinate amount of dedication (on the
level of commitable...I mean dude, WTF? :P). Someone should call the LHC
and let them know you've got a way to detect the undetectable.

Jon.


