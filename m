Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbZLJWvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbZLJWvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932937AbZLJWvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:51:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbZLJWvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:51:05 -0500
Message-ID: <4B217B1B.1090009@zytor.com>
Date: Thu, 10 Dec 2009 14:50:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>	<4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk>	<20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org>	<20091210192659.GV8742@kernel.dk> <4B21630A.6000308@kernel.org>	<4B21789F.4030707@zytor.com> <adaaaxqla49.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaaaxqla49.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 02:47 PM, Roland Dreier wrote:
> 
>  > Is this an EFI BIOS?  Otherwise, the first 64K would be clobbered anyway
>  > by the boot loader, so it is invalid anyway...  If it is EFI, it is
>  > theoretically possible.
> 
> Yes, EFI BIOS on an pre-release NHM EX box.
> 

OK, for EFI (with no legacy BIOS support) then it is legal -- still a
bad choice.

	-hpa

