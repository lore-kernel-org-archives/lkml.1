Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYFCRQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYFCRQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbYFCRPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:15:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375AbYFCRPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:15:12 -0400
Date: Tue, 3 Jun 2008 19:27:58 +0200
From: Olaf Dabrunz <od@suse.de>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Stefan Assmann <sassmann@suse.de>
Subject: Re: [PATCH 4/7] disable broadcomm legacy boot interrupt generation
Message-ID: <20080603172758.GF22600@suse.de>
Mail-Followup-To: Jon Masters <jonathan@jonmasters.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Stefan Assmann <sassmann@suse.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107072891-git-send-email-od@suse.de> <1212508003.22357.8.camel@londonpacket.bos.redhat.com> <20080603155914.GC16200@suse.de> <1212509143.22357.23.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212509143.22357.23.camel@londonpacket.bos.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-Jun-08, Jon Masters wrote:
> 
> On Tue, 2008-06-03 at 17:59 +0200, Olaf Dabrunz wrote:
> > On 03-Jun-08, Jon Masters wrote:
> > > On Mon, 2008-06-02 at 14:45 +0200, Olaf Dabrunz wrote:
> > > 
> > > > Add a quirk to disable legacy boot interrupt generation on broadcomm HT1000.
> > > 
> > > This one interests me, because I got access to the Broadcom HT-1000
> > > datasheet and could not find this feature mentioned in there. I'd
> > > appreciate knowing how you figured this one out :)
> > 
> > I had a sharp look at it... ;)
> 
> Me too. It's ***NOT*** mentioned in there :)

That's right. :)

> > Actually, I looked through the datasheet three times, and did not find
> > anything. Then I looked at the IRQ routing picture until I had an idea
> > of how it is supposed to work and the solution was becoming clear. The
> > register descriptions made me believe it could work, and testing
> > confirmed this.
> 
> Oh, ok, now that takes some inordinate amount of dedication (on the
> level of commitable...I mean dude, WTF? :P). Someone should call the LHC
> and let them know you've got a way to detect the undetectable.

xD *grin* :)

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

