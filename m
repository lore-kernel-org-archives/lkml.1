Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbXBJJez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbXBJJez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXBJJez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:34:55 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:3970 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbXBJJey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:34:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=C9A9l8PG5RJUpbqgVwQ3wxVZi/Aj0/ufPSC+aRxT7K3YfjZerfLhH4cLM9RsxuRs2q63FlkjSEQ4K0qq71gnod4RHXJru0xCKIiLcBrEwaFmkTwTpy7o2nT1N6iZcyNBtG6K6WI2ZIRmfrCEqgg63O/XIg7I79KhWBlJD8peQ7U=;
Message-ID: <45CD91B6.5000709@unsolicited.net>
Date: Sat, 10 Feb 2007 09:34:46 +0000
From: David R <david@unsolicited.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_nv - ADMA issues with 2.6.20
References: <fa.uoZWqSFxPjjB7zobQOwk/2zqG5A@ifi.uio.no> <45CD20DB.9030808@shaw.ca>
In-Reply-To: <45CD20DB.9030808@shaw.ca>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

> So it was tag 0 that timed out , and according to the CPBs the
> controller indeed believes the command is still outstanding, i.e. we
> didn't lose an interrupt. I'm suspicious of the fact that only one of
> two identical drives produced this error.. some kind of hardware-related
> problem perhaps? 30 seconds is an awfully long time for a drive to take

That was my first thought. Maybe the drive has some fault that only shows up
with NCQ in use. I'll keep an eye on it.

> You can also try disabling NCQ without disabling ADMA and see what that
> does:
> 
> echo 1 > /sys/block/sdX/device/queue_depth

I'll give this a go when I next reboot.

Thanks
David


