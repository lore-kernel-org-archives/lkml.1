Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbZHDW4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbZHDW4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbZHDW4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:56:35 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:50935 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbZHDW4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:56:33 -0400
Date: Wed, 5 Aug 2009 00:56:26 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090804225626.GZ3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
 <1248710618.1216.452.camel@rc-desk>
 <1248710775.9958.0.camel@johannes.local>
 <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
 <20090804084903.GV3382@ics.muni.cz>
 <1249426183.30019.4581.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249426183.30019.4581.camel@rc-desk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 05 Aug 2009 00:56:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:49:43PM -0700, reinette chatre wrote:
> This is strange. My previous test results were based on recent
> wireless-testing. I now retested with a fresh pull from Linus's repo
> (2.6.31-rc5) and I see the same behavior with Fn+F5 not changing the
> wifi radio status at all. I do not know why we would see different
> behavior considering we have the same platform and running the same
> kernel. I found one related option in the BIOS, but with that I was only
> able to have wireless HW rfkill permanently enabled.
> 
> I am not sure about the original problem though. In your original report
> you mention that you are unable to use wireless due to rfkill. From your
> email it seems that you are able to toggle wifi rfkill state using the
> Fn+F5 keys, so with that disabling rfkill you should be able to use your
> wireless. Can you still not use wireless even when rfkill reports
> "RFKILL event: idx 6 type 1 op X soft 0 hard 0" ?

No.

I can use wifi if rfkill reports "RFKILL event: idx 6 type 1 op X soft 0 hard
0".

My problem is, that since 2.6.31-rcX Fn+F5 toggles soft rfkill state. It did
not happen in 2.6.30 and earlier. In that case, Fn+F5 triggered an acpi event
(key press). Now, it triggers acpi eveny *and* touches soft rfkill of WIFI.
I like the previous behavior, i.e., don't touch anything, just report acpi
event.

-- 
Luká¹ Hejtmánek
