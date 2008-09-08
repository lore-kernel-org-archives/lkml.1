Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbYIHACZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbYIHACZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYIHACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:02:13 -0400
Received: from gw.goop.org ([64.81.55.164]:41566 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYIHACN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:02:13 -0400
Message-ID: <48C46B83.70704@goop.org>
Date: Sun, 07 Sep 2008 17:02:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 7 of 7] x86: always explicitly map acpi memory
References: <patchbomb.1220826072@localhost>	 <6f23bad119ae2ed00f1c.1220826079@localhost> <86802c440809071635l1457659bufeefa6e65cc34bdf@mail.gmail.com>
In-Reply-To: <86802c440809071635l1457659bufeefa6e65cc34bdf@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> actually,
> case 1: acpi tables near mmio, range, we don't map them from
> 2.6.27-rc1, and it is bigger than max_low_mapped...
> case 2: some strange system put acpi in the middle of RAM... like when
> 8G ram installed, but MMIO is 3.5G, BIOS put acpi tables around 2G..
>   

OK, so what's your conclusion?  Is this change OK or not?

    J
