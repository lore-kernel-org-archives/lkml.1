Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbZHDItK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbZHDItK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZHDItJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:49:09 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37111 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZHDItI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:49:08 -0400
Date: Tue, 4 Aug 2009 10:49:03 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090804084903.GV3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
 <1248710618.1216.452.camel@rc-desk>
 <1248710775.9958.0.camel@johannes.local>
 <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249336021.30019.4304.camel@rc-desk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 147.251.58.112
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 04 Aug 2009 10:48:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 02:47:01PM -0700, reinette chatre wrote:
> I tried this on a T61.
> 
> As you say, there are two "rfkill" related buttons on this platform, the
> actual rfkill switch on the front and the Fn+F5 buttons. Trying these
> out I saw the following (output annotated to be readable - index 0 is
> bluetooth and index 1 is wifi). It looks to me like things are behaving
> reasonably and I do not see that Fn+F5 changes wifi at all.

This is my case:
# Bluetooth SW off, WIFI SW on
./rfkill event
RFKILL event: idx 6 type 1 op 0 soft 0 hard 0
RFKILL event: idx 12 type 2 op 0 soft 1 hard 0
# Fn-F5 pressed
RFKILL event: idx 6 type 1 op 2 soft 1 hard 0
RFKILL event: idx 12 type 2 op 2 soft 0 hard 0
RFKILL event: idx 14 type 2 op 0 soft 0 hard 0
RFKILL event: idx 14 type 2 op 2 soft 0 hard 0
# Fn-F5 pressed
RFKILL event: idx 6 type 1 op 2 soft 0 hard 0
RFKILL event: idx 12 type 2 op 2 soft 1 hard 0
RFKILL event: idx 14 type 2 op 1 soft 0 hard 0

all this is when HW kill is on and it is unchanged all the time.

idx 6 is WIFI
idx 12, 14 is Bluetooth. (12 tpacpi_bluetooth_sw, 14 is hci0)

-- 
Luká¹ Hejtmánek
