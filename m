Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbYC1NpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbYC1NpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYC1No6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:44:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2877 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbYC1No6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:44:58 -0400
Date: Fri, 28 Mar 2008 14:44:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least do it at KERN_CRIT
Message-ID: <20080328134451.GB4544@ucw.cz>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113528.GA8077@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328113528.GA8077@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-28 12:35:28, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > IOMMU off means very bad stuff may happen, like data corruption on 
> > your hard drives. At least tells users this is serious...
> 
> ouch. Please at minimum lets turn this into a panic(), but best would be 
> to trim memory in this case, hm?

Andi tells me we already fallback to swiotlb, so messages are not on
wrong loglevel; they contain confusing/obsolete text. 

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
