Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXBVOie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXBVOie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbXBVOie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:38:34 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37239 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933085AbXBVOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:38:32 -0500
X-Sasl-enc: 6t+kVUOsfYumttqs9czur+w9N/wiUv9yK6GNIRVjSjKt 1172155199
Date: Thu, 22 Feb 2007 12:38:27 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: James Simmons <jsimmons@infradead.org>,
       Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222143827.GB25887@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <87fy8z6pdd.fsf@sycorax.lbl.gov> <Pine.LNX.4.64.0702220112440.17121@pentafluge.infradead.org> <1172138176.5837.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172138176.5837.27.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Richard Purdie wrote:
> On Thu, 2007-02-22 at 01:13 +0000, James Simmons wrote:
> > > Richard Purdie <rpurdie@rpsys.net> writes:
> > > 
> > > > If FB_RADEON_BACKLIGHT wasn't set for 2.6.20, can you try 2.6.21-rc1
> > > > with that option disabled?
> > > 
> > > i don't have my laptop with me but i am pretty sure
> > > FB_RADEON_BACKLIGHT wasn't set for 2.6.20 (i think it showed up as a
> > > new option when i did make oldconfig). i'll post the difference when i
> > > get home tonight and also try disabling it.
> > 
> > Correct. You need to enable the backlight for the radeon card.
> 
> The problem is when that is set, the device doesn't work as they need
> the ibm ACPI driver, not the raedon one.

They need the ibm-acpi one for brightness, and the radeon one for on/off.  I
want a way to join that all together in a single place, if at all possible.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
