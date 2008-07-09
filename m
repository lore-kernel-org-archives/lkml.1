Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYGIOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYGIOrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYGIOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:47:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2219 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751834AbYGIOrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:47:13 -0400
Date: Wed, 9 Jul 2008 16:47:05 +0200
From: Pavel Machek <pavel@suse.cz>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0 of 2] fbcon: blinking text fix and implementation
Message-ID: <20080709144704.GA11006@ucw.cz>
References: <486A4F5F.7030506@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A4F5F.7030506@eu.citrix.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-01 16:38:07, Stefano Stabellini wrote:
> Hi all,
> I have recently found out that there is a small bug in fbcon handling
> the background color.
> The forth bit of the background color is the blink property bit, not the
> intensity bit, as for the foreground color.
> Therefore it shouldn't be included in the background color.
> I also wrote a very simple implementation for blinking text in fbcon,
> using the flashcursor function to scan the buffer for blinking chars.
> Any suggestion or critic is very welcome, but don't be too hard :)

I'd prefer to call that 'feature' and leave it alone. Burning cpu
power to provide annoying blinking text is at least questionable...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
