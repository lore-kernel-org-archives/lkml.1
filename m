Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZC2VkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZC2VkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZC2VkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:40:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37614 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZC2VkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:40:06 -0400
Date: Sun, 29 Mar 2009 23:39:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: TOMOYO in linux-next
Message-ID: <20090329213955.GD31857@elf.ucw.cz>
References: <ck5CF-5mU-11@gated-at.bofh.it> <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org> <20090327114224.GF2585@elf.ucw.cz> <alpine.LSU.0.999.0903271354290.5610@be1.lrz> <20090329115830.GA15492@elf.ucw.cz> <alpine.LNX.1.10.0903291613360.20606@be10.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0903291613360.20606@be10.lrz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> How would you exclude mozilla from writing to .* then? ".a" is bad,
>>> ".b" is bad ...? or "A" is OK, "a" is OK, "zzzzzzzzzzzzz" is OK"?
>>> Either way, you'd need several universes to store the security profile.
>>
>> What is magic about .* files? I want mozilla to store the pictures as
>> .naughty.picture.jpg -- I don't see anything wrong with that.
>
> As long as you have a guaranteed-to-be-complete list of config files, you 
> can get along without wildcards. And still if you do, I'll write a 
> program to make it incomplete.

Not all config files match .* pattern. I have at least hugo.ini
mxmap.ini in my ~.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
