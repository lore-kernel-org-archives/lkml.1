Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZHMXAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZHMXAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZHMXAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:00:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:52299 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbZHMXAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,377,1246863600"; 
   d="scan'208";a="541187592"
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090807213508.GN3382@ics.muni.cz>
References: <1248710775.9958.0.camel@johannes.local>
	 <20090728112102.GA3382@ics.muni.cz> <1249336021.30019.4304.camel@rc-desk>
	 <20090804084903.GV3382@ics.muni.cz> <1249426183.30019.4581.camel@rc-desk>
	 <20090804225626.GZ3382@ics.muni.cz> <1249429081.30019.4588.camel@rc-desk>
	 <20090806132244.GC15867@khazad-dum.debian.net>
	 <20090806224110.GJ3382@ics.muni.cz>
	 <20090806230704.GA14381@khazad-dum.debian.net>
	 <20090807213508.GN3382@ics.muni.cz>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 15:59:59 -0700
Message-Id: <1250204399.30019.6344.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On Fri, 2009-08-07 at 14:35 -0700, Lukas Hejtmanek wrote:

> On Thu, Aug 06, 2009 at 08:07:04PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 07 Aug 2009, Lukas Hejtmanek wrote:
> > > 0x0004 = 238  # KEY_WLAN
> > 
> > This means any rfkill input handler (be it in kernel or userspace) will
> > toggle your WLAN cards when fn+f5 is pressed.  You can just assign a
> > different keycode to it (use KEY_RESERVED or KEY_UNKNOWN if you don't want
> > the key to do anything).
> 
> Could you give me some hints how to do the mapping?

On my system this key is mapped to 385 (KEY_RADIO) - so that can explain
why we are seeing different behavior. Perhaps you can try to change your
key mapping to this if you just want bluetooth to be affected?

>From what I understand you can use input-kbd to change the key mappings.
The map file you can provide to it is in same format as the one it
prints for you.

Reinette


