Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZAAWr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZAAWr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 17:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZAAWrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 17:47:48 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:43090 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZAAWrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 17:47:47 -0500
Message-ID: <495D480F.3010208@free.fr>
Date: Thu, 01 Jan 2009 23:47:43 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 Iceape/1.1.14 (Debian-1.1.14-1)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH -stable] fix USB_STORAGE_CYPRESS_ATACB
References: <495913A6.9070007@free.fr> <20081229192431.GZ1469@one-eyed-alien.net> <495A475D.7060608@panasas.com> <495B4ADB.3020904@panasas.com>
In-Reply-To: <495B4ADB.3020904@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Boaz Harrosh wrote:
> Hi Matthieu, Matthew
> 
> I fixed lots of "mucking directly" with scsi_cmnd and scsi_eh_save
> internal members but the actual set of srb->cmnd{,_len} is needed
> still. Though we don't need the copy since we restore the original
> command right after. If anyone can test this to verify it could
> be grate.
> 
your patch works for me.

Thanks and happy new year


Matthieu
