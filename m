Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZHGVfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZHGVfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZHGVfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:35:13 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34811 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZHGVfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:35:12 -0400
Date: Fri, 7 Aug 2009 23:35:08 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090807213508.GN3382@ics.muni.cz>
References: <1248710775.9958.0.camel@johannes.local>
 <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
 <20090804084903.GV3382@ics.muni.cz>
 <1249426183.30019.4581.camel@rc-desk>
 <20090804225626.GZ3382@ics.muni.cz>
 <1249429081.30019.4588.camel@rc-desk>
 <20090806132244.GC15867@khazad-dum.debian.net>
 <20090806224110.GJ3382@ics.muni.cz>
 <20090806230704.GA14381@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090806230704.GA14381@khazad-dum.debian.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 07 Aug 2009 23:35:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 06, 2009 at 08:07:04PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 07 Aug 2009, Lukas Hejtmanek wrote:
> > 0x0004 = 238  # KEY_WLAN
> 
> This means any rfkill input handler (be it in kernel or userspace) will
> toggle your WLAN cards when fn+f5 is pressed.  You can just assign a
> different keycode to it (use KEY_RESERVED or KEY_UNKNOWN if you don't want
> the key to do anything).

Could you give me some hints how to do the mapping?

> > 0x0007 = 192  # KEY_F22
> > 0x0008 = 194  # KEY_F24
> 
> Hmm? What does that do in your distro?  That's fn+f8 and fn+f9, BTW.

Hmm, I did grep -r KEY_F22 /usr/share/hal/* 

and no hits. The same for /etc/.

-- 
Luká¹ Hejtmánek
