Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXK0Qto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXK0Qto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbXK0Qth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:49:37 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:57961 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756091AbXK0Qtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:49:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=js2BPuXZvQYWweER81qZN1KGx/nKuYZfTpAgJnnoL1GKTH7Bq9HfL2QlRV7Ny4uaBFBY44Np3XYi1jcj+nQAiqntntt8UXQWb3MYtHnCUbxDVd+CcBpaFAcVvScj5McqKbLsQMi3/Vwj9aLJJbVbvKIIMRSu6zMEz0RgYqcm1ZY=
Date: Tue, 27 Nov 2007 19:49:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible BUG: unable to handle kernel NULL pointer dereference
	at virtual address 00000000
Message-ID: <20071127164929.GA7279@cvg>
References: <47481590.8090009@xs4all.nl> <200711241951.37817.rjw@sisk.pl> <474870F5.4050504@xs4all.nl> <aa79d98a0711270340q5fd6b8a0o5076052a4411e6b2@mail.gmail.com> <474C3659.600@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C3659.600@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Udo van den Heuvel - Tue, Nov 27, 2007 at 04:23:05PM +0100]
| Cyrill Gorcunov wrote:
| > On 11/24/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
| >> Rafael J. Wysocki wrote:
| >>> On Saturday, 24 of November 2007, Udo van den Heuvel wrote:
| >>>> Hello,
| >>>>
| >>>> What happened in the attached messages?
| >>>> It was on a VIA Epia EN12000, while compiling.
| >>>> Yes, the machine has been stable before and after that issue.
| >>>> So I suspect no hardware issues.
| >>> Which kernel is this?
| >> Sorry for not mentioning:
| >> 2.6.23.1
| > Hi Udo,
| > i'm not sure about the patch i supposing you to test but it could help
| > to locate it ;)
| > Could you try it and report me how it works?
| 
| Yes I can!
| Thanks for the patch.
| But how can I reproduce the (possible) bug the easiest?
| It `just happened` during compiling.
| So I compile some more?
| 
| Kind regards,
| Udo
| 

Hi Udo,

yes i think that is the way we could catch it (i mean compiling everything
until bug happens ;) the patch i send you is quite stupid and based on my
feelings that we have problem with dcache but maybe i just wrong...
dunno...lets just try ;) and could you please send your config to me and
LKML too.

		Cyrill

