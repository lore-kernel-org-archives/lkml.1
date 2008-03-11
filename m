Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYCKVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYCKVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYCKVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:09:49 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:32030 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbYCKVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:09:49 -0400
X-Belgacom-Dynamic: yes
Date: Tue, 11 Mar 2008 22:09:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Samuel Tardieu <sam@rfc1149.net>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>, junker@anduras.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: w83697hf_wdt.c stops watchdog on load
Message-ID: <20080311210947.GF7505@infomag.infomag.iguana.be>
References: <47D564CA.1040507@draigBrady.com> <2008-03-10-18-48-16+trackit+sam@rfc1149.net> <47D5C1DC.6080808@draigBrady.com> <20080311202214.GA7505@infomag.infomag.iguana.be> <2008-03-11-21-28-21+trackit+sam@rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2008-03-11-21-28-21+trackit+sam@rfc1149.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

> That was my intent: disable the watchdog by default, and add an option
> not to disable it (let it untouched, so getting the BIOS setting) at
> module initialization, as Pádraig request is totally reasonable.

Ok, then we are on the same line. It indeed makes sense to do this
with watchdog devices that are capable of being controlled by the
bios and where the timeout/keepalive time can be set big enough.

What should also be looked at is when you take over the watchdog
settings from the bios, do you then take the same timeout/keepalive
value? In the pcwd-drivers I took the dip-switch value of the card
when the value was 0. You could do something similar here.

Greetings,
Wim.

