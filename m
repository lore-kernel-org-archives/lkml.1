Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZJKSCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZJKSCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 14:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbZJKSCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 14:02:49 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:17748 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZJKSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 14:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YYIy+JVU1VWJ4Y5dknulOPvlq9uq7cW2KK0VQlRE4ux+FbpBnSiVjO408ziVIQ4i4J
         GsYQH2KZpuHUG+27MKRoBjdSWAelWqW4++DTybyJMPgov7UGhKthQHMEI/1pw94O/7N+
         m+YIy9KdIp1wPG/2KhoYtdOFrPTqE1jS+wTE8=
Date: Sun, 11 Oct 2009 11:01:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091011180134.GA5197@core.coreip.homeip.net>
References: <20091011162155.GA4260@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011162155.GA4260@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carols,

On Sun, Oct 11, 2009 at 06:21:55PM +0200, Carlos R. Mafra wrote:
> Using the latest 2.6.32-rc3+ kernel, the "paste" operation via the 
> touchpad of my Vaio laptop does not work after suspend to RAM.
> 
> It works flawlessly before s2ram; I select the text with the touchpad
> and tap quickly its right corner to paste the selected text.
> After a plain 'echo mem > /sys/power/state' the "paste" does not work.
> 
> I bisected it to commit ffd0db97196c1057f09c2ab42dd5b30e94e511d9 ("Input: 
> add generic suspend and resume for input devices").
> 
> I haven't tested if reverting it from mainline fixes the issue, but 
> from the patch description I guess that bisection landed correctly
> on the culprit.
> 

Please verify that this is the real offending commit by reverting it - I
am surprised that it would give any trouble since it is supposed to
restore LED state and repeat rate and therefore should only be affecting
keyboards.

-- 
Dmitry
