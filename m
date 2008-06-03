Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYFCP6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYFCP6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFCP6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:58:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:49037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYFCP6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:58:45 -0400
Date: Tue, 3 Jun 2008 17:59:15 +0200
From: Olaf Dabrunz <od@suse.de>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Stefan Assmann <sassmann@suse.de>
Subject: Re: [PATCH 4/7] disable broadcomm legacy boot interrupt generation
Message-ID: <20080603155914.GC16200@suse.de>
Mail-Followup-To: Jon Masters <jonathan@jonmasters.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Stefan Assmann <sassmann@suse.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107072891-git-send-email-od@suse.de> <1212508003.22357.8.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212508003.22357.8.camel@londonpacket.bos.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-Jun-08, Jon Masters wrote:
> On Mon, 2008-06-02 at 14:45 +0200, Olaf Dabrunz wrote:
> 
> > Add a quirk to disable legacy boot interrupt generation on broadcomm HT1000.
> 
> This one interests me, because I got access to the Broadcom HT-1000
> datasheet and could not find this feature mentioned in there. I'd
> appreciate knowing how you figured this one out :)

I had a sharp look at it... ;)

Actually, I looked through the datasheet three times, and did not find
anything. Then I looked at the IRQ routing picture until I had an idea
of how it is supposed to work and the solution was becoming clear. The
register descriptions made me believe it could work, and testing
confirmed this.

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

