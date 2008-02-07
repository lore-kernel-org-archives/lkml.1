Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYBGIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYBGIZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYBGIZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:25:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:17005 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYBGIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=m05SZxXes//qfi0pREoy1JlvUXcD2ZDVaVLP+CvSWvIJLqOGMnSdTCqP/zmC35D5sXzzde35yw32aHRS94M9fi1W6YT2NcUmzgkO6G6fbvVYEAwm/FxTPjYeljm7liUJagZwNcAt4gwHzZwuimKmUSEwJOAlXRUkw/0Zwny6M78=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb mtrrs - FIX
Date: Thu, 7 Feb 2008 13:51:02 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       jesse.barnes@intel.com, yhlu.kernel@gmail.com, ak@suse.de,
       Yinghai Lu <yinghai.lu@sun.com>
References: <200802071257.51893.balajirrao@gmail.com> <20080207080245.GA28631@elte.hu>
In-Reply-To: <20080207080245.GA28631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071351.02763.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 01:32:45 pm Ingo Molnar wrote:
> * Balaji Rao <balajirrao@gmail.com> wrote:
> > Hello,
> >
> > The following commit caused my X server to stop working.
> >
> > commit 99fc8d424bc5d803fe92cad56c068fe64e73747a
> > Author: Jesse Barnes <jesse.barnes@intel.com>
> > Date:   Wed Jan 30 13:33:18 2008 +0100
> >
> >     x86, 32-bit: trim memory not covered by wb mtrrs
> >
> > This patch fixes the improper handling of addresses > 4G by
> > mtrr_trim_uncached_memory. This, now brings up X on my system.
>
> thanks. Incidentally this same bug was reported and fixed yesterday, and
> that fix is upstream already. Could you please compare your solution to
> Yinghai Lu's fix below, and send us a patch for any further improvements
> (or cleanups) you might notice in that code? It seems to be almost the
> same fix as yours. (and hopefully it fixes your X problem too)

Cool! Yes, Yinghai Lu's patch indeed is the same as mine and its really 
surprising that we've used the same variable name too! :)

regards,
balaji rao
