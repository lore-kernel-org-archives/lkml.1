Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbZLKL6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbZLKL6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZLKL6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:58:47 -0500
Received: from smtp.nokia.com ([192.100.122.230]:26474 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZLKL6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:58:46 -0500
Date: Fri, 11 Dec 2009 13:58:11 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20091211115811.GD12526@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
 <20091211115538.GB25806@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091211115538.GB25806@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Dec 2009 11:58:20.0186 (UTC) FILETIME=[3B77B7A0:01CA7A59]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:55:38PM +0100, ext Mark Brown wrote:
>On Fri, Dec 11, 2009 at 01:31:22PM +0200, Felipe Balbi wrote:
>> The notifier will be used to communicate usb events
>> to other drivers like the charger chip.
>
>> This can be used as source of information to kick
>> usb charger detection as described by the USB
>> Battery Charging Specification 1.1 and/or to
>> pass bMaxPower field of selected usb_configuration
>> to charger chip in order to use that information
>> as input current on the charging profile
>> setup.
>
>This one looks reasonable to me, though I've not thought it through
>properly yet.  Could you please add me to the CC list for future
>revisions of this - I've got some charger drivers that could use this?

Sure I'll do it. I want to start the discussion on this, so if you have 
any comments, please, do comment.

-- 
balbi
