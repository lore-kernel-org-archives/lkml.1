Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbYBYXCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbYBYXCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbYBYXCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:02:24 -0500
Received: from dbservice.com ([213.239.204.14]:34697 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758791AbYBYXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:02:23 -0500
Message-ID: <47C34927.7030803@dbservice.com>
Date: Tue, 26 Feb 2008 00:03:03 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080211)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
References: <20080225093914.GB4375@ics.muni.cz> <200802251247.30605.rjw@sisk.pl> <20080225200354.GE16513@khazad-dum.debian.net> <20080225204951.GB4432@ics.muni.cz> <20080225210113.GF16513@khazad-dum.debian.net> <20080225220720.GA4523@ics.muni.cz>
In-Reply-To: <20080225220720.GA4523@ics.muni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.225, required 5, AWL 0.20, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10, TW_EJ 0.08)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> On Mon, Feb 25, 2008 at 06:01:13PM -0300, Henrique de Moraes Holschuh wrote:
>> Not even over the new netlink socket?  Or the thinkpad-acpi input device?
> 
> how can I check this?

A while ago I worked on a new acpi daemon that could receive events from 
both netlink and /dev/input devices. Right now it's more like a testing 
tool then a real replacement for the current acpid. I haven't had time 
to work on it.

http://git.dbservice.com/?p=acpid;a=summary
$ git clone git://dbservice.com/acpid

You'll need dbus and lua to compile it. There's also a readme that 
describes how to get it running and how it works. In its default 
configuration it will print the events into stdout.

tom

