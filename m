Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbZHNQHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbZHNQHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 12:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbZHNQHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 12:07:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:4499 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbZHNQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 12:07:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,381,1246863600"; 
   d="scan'208";a="175879842"
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090814021031.GB4555@khazad-dum.debian.net>
References: <1249336021.30019.4304.camel@rc-desk>
	 <20090804084903.GV3382@ics.muni.cz> <1249426183.30019.4581.camel@rc-desk>
	 <20090804225626.GZ3382@ics.muni.cz> <1249429081.30019.4588.camel@rc-desk>
	 <20090806132244.GC15867@khazad-dum.debian.net>
	 <20090806224110.GJ3382@ics.muni.cz>
	 <20090806230704.GA14381@khazad-dum.debian.net>
	 <20090807213508.GN3382@ics.muni.cz> <1250204399.30019.6344.camel@rc-desk>
	 <20090814021031.GB4555@khazad-dum.debian.net>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 09:07:47 -0700
Message-Id: <1250266067.30019.6376.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 19:10 -0700, Henrique de Moraes Holschuh wrote:
> On Thu, 13 Aug 2009, reinette chatre wrote:
> > On Fri, 2009-08-07 at 14:35 -0700, Lukas Hejtmanek wrote:
> > > On Thu, Aug 06, 2009 at 08:07:04PM -0300, Henrique de Moraes Holschuh wrote:
> > > > On Fri, 07 Aug 2009, Lukas Hejtmanek wrote:
> > > > > 0x0004 = 238  # KEY_WLAN
> > > > 
> > > > This means any rfkill input handler (be it in kernel or userspace) will
> > > > toggle your WLAN cards when fn+f5 is pressed.  You can just assign a
> > > > different keycode to it (use KEY_RESERVED or KEY_UNKNOWN if you don't want
> > > > the key to do anything).
> > > 
> > > Could you give me some hints how to do the mapping?
> > 
> > On my system this key is mapped to 385 (KEY_RADIO) - so that can explain
> 
> And KEY_RADIO is the key to select the radio tuner... heh.  The
> bogosity never ends.  At least it is unlikely that anything would care
> for KEY_RADIO.

On my system this key toggles bluetooth rfkill and does not touch wifi.
I think this is what Lukas wants it to do. I thus hope when he sets his
key mapping to KEY_RADIO he will get the same behavior.

> > >From what I understand you can use input-kbd to change the key mappings.
> > The map file you can provide to it is in same format as the one it
> > prints for you.
> 
> You can also add a HAL fdi file.  I will attach one I found on my
> system, modify to your taste and find out where you should drop it on
> /etc for HAL to use...

Thanks!

Reinette

