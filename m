Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYFBTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYFBTN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYFBTNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:13:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2961 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751660AbYFBTNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:13:51 -0400
Date: Mon, 2 Jun 2008 21:13:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>, davej@elf.ucw.cz,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend vs. iommu: prevent suspend if we could not resume
Message-ID: <20080602191336.GB7752@ucw.cz>
References: <20080527095121.GA3689@elf.ucw.cz> <20080602110310.GD14598@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602110310.GD14598@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-02 13:03:10, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > iommu/gart support misses suspend/resume code, which can do bad stuff, 
> > including memory corruption on resume. Prevent system suspend in case 
> > we would be unable to resume.
> 
> applied to tip/x86/urgent and to tip/pci-for-jesse. Thanks Pavel,

Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
