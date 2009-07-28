Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZG1LVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZG1LVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZG1LVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:21:12 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:52787 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZG1LVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:21:12 -0400
Date: Tue, 28 Jul 2009 13:21:02 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090728112102.GA3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
 <1248710618.1216.452.camel@rc-desk>
 <1248710775.9958.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1248710775.9958.0.camel@johannes.local>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 28 Jul 2009 13:21:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 06:06:15PM +0200, Johannes Berg wrote:
> I'm not aware of any thinkpad-acpi rfkill problems, can you get the
> rfkill tool and dump the status/list?
> 
> http://wireless.kernel.org/en/users/Documentation/rfkill

I figured it out.

I disable bluetooth usually just after system startup.

I disable bt using Fn+F5 which generates ACPI event: 
ibm/hotkey HKEY 00000080 00001005

Which is OK.

But now (sinc 2.6.31-rcX), it silently toggles Soft block of WIFI. I have
separate HW rfkill switch, it is only soft blocked. 

-- 
Luká¹ Hejtmánek
