Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYBJVOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYBJVOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYBJVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:14:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36210 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751802AbYBJVOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:14:42 -0500
Date: Sun, 10 Feb 2008 22:14:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080210211457.GJ15662@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802082301.51582.rjw@sisk.pl> <20080208220834.GA1631@elf.ucw.cz> <200802090118.50418.rjw@sisk.pl> <47ACF488.7070502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACF488.7070502@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-08 16:32:08, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
>>
>> Consolidated patch is appended.  I'll test it tomorrow on x86-64.
>>
>> I'd like to add the cleaned up beeping code to it and perhaps try to push it
>> for -mm testing without any further changes.  We can still do more cleanups in
>> followup patches.
>>
>
> The other thing to figure out is to what extent we can clean up the 
> conditionals in the video mode code by refactoring.  All they really do 
> here is save space by removing functionality not needed for wakeup, because 
> I didn't know how much space was realistic.
>
> It's possible we can remove them altogether by having a dummy boot_params 
> structure (4K).

I'd say that few #ifdefs are acceptable if we save 4K, but...

Sam... is there something that urgently needs fixing?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
