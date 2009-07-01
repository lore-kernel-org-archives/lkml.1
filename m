Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZGAJIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZGAJIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZGAJIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:08:35 -0400
Received: from mail.crca.org.au ([67.207.131.56]:54766 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbZGAJIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:08:34 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4A4B27D0.8020906@crca.org.au>
Date: Wed, 01 Jul 2009 19:09:36 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
CC: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
 encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B0125.2090502@crca.org.au> <87d48k2992.fsf@jeremyms.com>
In-Reply-To: <87d48k2992.fsf@jeremyms.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

Jeremy Maitin-Shepard wrote:
> Nigel Cunningham <ncunningham@crca.org.au> writes:
> 
>> Hi Jeremy.
>> I'd suggest emailing the Linux-PM list rather than tuxonice-devel.
>> TuxOnIce devel focuses on the out-of-vanilla suspend to disk
>> enhancements rather than on suspend to ram.
> 
> The Linux-PM list is a good suggestion, but I specifically included
> tuxonice because of the note at the bottom --- namely that I believe
> that tuxonice in particular already includes support for much of what is
> needed to implement the idea.

Ah, sorry. I read too quickly.

> Specifically, suppose right at the stage in tuxonice hibernation when
> the kernel as about to write the page cache pages to disk, it instead
> just encrypts in place those pages, clears the encryption key, then
> waits for the userspace helper to pass it back the key again to use to
> decrypt the pages.
> 
> In fact it would seems that actually entering S3 is mostly irrelevant in
> terms of the implementation.
> 
> Tuoxnice already has code to deal with interfacing with a userspace
> helper that is kept unfrozen (and its pages handled specially) while
> everything else is frozen and the page cache is overwritten, which is
> precisely what is needed for this idea.  In particular, it seems that an
> implementation of the idea I proposed would look a lot like tuxonice
> with a powerdown mode of entering S3, just that instead of writing the
> page cache to disk, it is encrypted in place.  I suppose it could well be that
> all of the facilities used by tuxonice to do this are actually already
> in the kernel, in which case it is indeed not relevant to tuxonice, but
> it is not clear that the uswsusp infrastructure has everything that is
> needed.

You're absolutely right - TuxOnIce could be modified to do that, quite
easily.

As far as the possibility of using uswsusp goes, I'd like to get
Rafael's input there - he knows it much better than I do (explicitly
adding him to the ccs).

Regards,

Nigel
