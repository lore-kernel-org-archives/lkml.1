Return-Path: <linux-kernel-owner+w=401wt.eu-S936199AbXHNEyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936199AbXHNEyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762817AbXHNEx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:53:59 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:38870 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762457AbXHNEx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:53:58 -0400
Date: Tue, 14 Aug 2007 00:52:49 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Joe Perches <joe@perches.com>
cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eng.Linux@digi.com
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
In-Reply-To: <1187066391.32555.27.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708140040280.11945@lancer.cnet.absolutedigital.net>
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com> 
 <20070813115344.04759b74@the-village.bc.nu>  <46C06E70.9090905@s5r6.in-berlin.de>
 <46C0838A.2030504@intel.com>  <1187022904.10249.97.camel@localhost>
 <1187064798.32555.7.camel@localhost>  <Pine.LNX.4.64.0708140021460.11945@lancer.cnet.absolutedigital.net>
 <1187066391.32555.27.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Joe Perches wrote:

> On Tue, 2007-08-14 at 00:29 -0400, Cal Peake wrote:
> > Prolly /[^a-z0-9]/i would the safest bet. Also don't forget to escape 
> > double quotes (e.g. "Jonathan \"Jon\" Doe" <jon@example.net>).
> 
> A-Z and [[:space:]] are OK too.

The 'i' at the end of the regex means case-insensitive ;) but yes, I 
forgot whitespace. So something like:

  if ($name =~ /[^a-z0-9[:space:]]/i) {
    quote_name;
  }

> I skimmed the spec, but nothing jumped out at me.

My recommendation was mostly based on what pine does. It seems to be a 
pretty sane MUA...

-- 
Cal Peake

