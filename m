Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZBJU0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZBJU0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZBJU0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:26:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51038 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZBJU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:26:21 -0500
Date: Tue, 10 Feb 2009 21:25:58 +0100
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Message-ID: <20090210202558.GH1382@ucw.cz>
References: <20090204191540.2d6abd87@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204191540.2d6abd87@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-02-04 19:15:40, Arjan van de Ven wrote:
> Hi,
> 
> A MSI Wind (100) netbook landed on my desk with the comment "touchpad
> doesn't work in Linux but works in XP". 
> 
> It turns out that there are a 2 separate issues with this netbook that
> needed fixing 
> 
> 1) The touchpad requires the equivalent of "i8042.reset", which resets
> the controller before probing. (This is done via a DMI quirk in patch
> 2/2)
> 
> 2) About half the time, the reset will fail the first time. In the
> current code, this is fatal and then also disables the keyboard in
> addition to the touchpad. Ungood. Patch 1 makes the kernel retry the
> reset upto five times before giving up (it seems the 2nd or 3rd time
> succeed for me), and also adds an option to not make such a failure
> fatal to the keyboard.
> 
> I don't think this is a regression, but it is pretty nasty behavior
> (the machine is useless without) so it could be a 2.6.29 candidate...

Well, that beast was selling with linux preloaded, no? Or was it
another msi wind? In such case I'd expect old kernel to work... or
maybe some reasonable workaround somewhere...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
