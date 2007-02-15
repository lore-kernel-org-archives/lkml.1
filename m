Return-Path: <linux-kernel-owner+w=401wt.eu-S932822AbXBOO3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbXBOO3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXBOO3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:29:10 -0500
Received: from terminus.zytor.com ([192.83.249.54]:33319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822AbXBOO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:29:08 -0500
Message-ID: <45D46F7B.3060105@zytor.com>
Date: Thu, 15 Feb 2007 06:34:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dax Kelson <dax@gurulabs.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>	<Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org> <20070214202144.1ddb930f.khali@linux-fr.org>
In-Reply-To: <20070214202144.1ddb930f.khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> 
> On x86, the BIOS led state can be read from byte 0x97 the BIOS RAM. The
> BIOS RAM is mapped at 0x400 so all we need to do is to one byte from
> RAM (offset 0x497). This is how Suse's hwinfo does.
> 

Perhaps that's what Suse does, but the proper address is 0x417.

0x497 is the rarely-used LPT2 timeout ocunter.

	-hpa



