Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZHEI7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZHEI7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZHEI7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:59:00 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:54478 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbZHEI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:58:59 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2009 04:58:59 EDT
Message-ID: <4A7947ED.1050300@ladisch.de>
Date: Wed, 05 Aug 2009 10:50:53 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: sound: -EPERM on first mplayer invocation
References: <200908022336.48898.vda.linux@googlemail.com>	<200908041101.43252.vda.linux@googlemail.com>	<s5hskg8aqhr.wl%tiwai@suse.de>	<200908050432.35016.vda.linux@googlemail.com>	<s5hd47aes85.wl%tiwai@suse.de> <s5hab2ees0v.wl%tiwai@suse.de>
In-Reply-To: <s5hab2ees0v.wl%tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> I wrote:
> > The file instances are different.  It implies that mplayer opens the
> > device at each time but doesn't close.
> > It sounds like a bug in mplayer to me.
> 
> ... or the first control handle keeps opened and blocks it.

mplayer indeed leaks the mixer handle.  This happens if setting the
volume fails, i.e., _after_ this message:
> > > > > > > alsa-control: error setting left channel, Operation not permitted


Best regards,
Clemens
