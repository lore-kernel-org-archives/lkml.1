Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXJVOdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXJVOdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXJVOdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:33:47 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:2844 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbXJVOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:33:46 -0400
From: Frans Pop <elendil@planet.nl>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: latest 2.6.23 git missing ACPI POWER_SUPPLY
Date: Mon, 22 Oct 2007 16:33:41 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <b6a2187b0710220045q2920c0dat9ebe4850b02d1bbf@mail.gmail.com> <E1IjvB3-0005oG-N9@faramir.fjphome.nl> <471CA0AA.4000904@gmail.com>
In-Reply-To: <471CA0AA.4000904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221633.42619.elendil@planet.nl>
X-OriginalArrivalTime: 22 Oct 2007 14:33:42.0937 (UTC) FILETIME=[8BA3E090:01C814B8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007, Alexey Starikovskiy wrote:
> Frans Pop wrote:
> > I must say that having these relatively top-level ACPI settings
> > depending on something that is relatively buried away is not very
> > intuitive! Especially not since at first glance you don't really seem
> > to need that option except for some weird hardware.
> >
> > CC'ing ACPI mailing list for other opinions.
>
> I was thinking that 'select' might be more appropriate here...
> Please take a look on attached patch.

Perfect! The power supply option can now no longer be unselected while 
battery or ac options are selected and will automatically get correct 
modular or compiled in status. Thanks.

Tested-by: Frans Pop <elendil@planet.nl>
