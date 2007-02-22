Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXBVBKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXBVBKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXBVBKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:10:22 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41319 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932846AbXBVBKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:10:21 -0500
X-Sasl-enc: 5nFzcKndaUQABHYgsDcVwRWajWXcQNe9z32RBfp+4AwS 1172106700
Date: Wed, 21 Feb 2007 23:10:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222011017.GA8845@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain> <20070222005122.GA7928@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222005122.GA7928@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Henrique de Moraes Holschuh wrote:
> > * 'cat brightness' != 'cat actual_brightness' upon bootup (doesn't have
> 
> Hmm, I see this in 2.6.20 too.  And brightness is the one that is buggy.  I
> will look into it.

Now, that was trivial to fix, and I will reply with a patch (which will have
Cc's trimmed to just the MLs and Richard).

But really, should not the backlight *class* be doing the initial update of
the brightness?  Looks like something that every device would need to do if
the class doesn't do it, and unlike the "power it off on unregister" thing,
I can't think of a reason not to do it for every backlight class device.

Please ACK the ibm-acpi patch in my next message if you'd like me to submit
it to Len Brown for merging into 2.6.21, or NACK it if you'd rather do it in
the backlight class core.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
