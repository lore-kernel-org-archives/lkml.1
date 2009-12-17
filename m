Return-Path: <linux-kernel-owner+w=401wt.eu-S1764546AbZLQLr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764546AbZLQLr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764536AbZLQLr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:47:28 -0500
Received: from lo.gmane.org ([80.91.229.12]:40101 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764527AbZLQLr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:47:26 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lukasz Sokol <el.es.cr@gmail.com>
Subject: Rfkill buttons : bi-stable, mono-stable, tactile
Date: Thu, 17 Dec 2009 11:47:00 +0000 (UTC)
Message-ID: <loom.20091217T122606-341@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.152.73.88 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Developers,

I'm sorry for not cc:ing to relevant people and other lists, I just encountered
a situation I wanted to share.

On Acer Aspire One, A150 Aw, sold to me with Linpus but then rooted up and
installed Ubuntu Karmic (yes, 9.10) and updated the BIOS to 3309 (latest). This
however isn't Ubuntu-specific (actually if I googled correctly, only one
distribution got it right, the original Linpus Lite...)

The issue I am talking about is : the killswitch for the wireless adaptor.

The Internet is almost 'flooded' with reports of this not working on various
distributions, that's why decided to go a level higher.

I have actually found that pushing this button repeatedly, produces 2 scancodes
: showkey reports keycode 238 pressed and keycode 238 released; in -s mode
reports 0xe0 0xf3 and 0xe0 0x73.

Also I think the firmware (BIOS) reports these only when the operation on the
WIFI card has been done, i.e. when it successfully toggled it, because when
pushing the button too often (too small gap between pushes)

As this netbook gives a completely unusable WMI interface (found out by Carlos
Corbacho, the acer-wmi developer) there is no other way the rfkill
infrastructure can be aware of the hard-lock status;

The killswitch itself is a mono-stable sliding button, not a bi-stable slider;
so I think this might also be related to some people's problems with
(de)activating wifi hardware on laptops that have just a Fn+wifi toggle;
This is why I think this might be a more generic issue, and why I decided to
post here.

Apologies, if it really really doesn't belong here.

Lukasz

