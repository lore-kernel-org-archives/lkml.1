Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371Ab0AIXQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0AIXQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532Ab0AIXQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:16:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:42682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0AIXQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:16:31 -0500
Message-ID: <4B484829.6060405@kernel.org>
Date: Sat, 09 Jan 2010 18:11:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: MSI broken in libata?
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
In-Reply-To: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 09 Jan 2010 23:16:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2009 06:22 PM, Torsten Kaiser wrote:
> As reported in http://lkml.org/lkml/2009/12/19/82 the new MSI support
> for sata_sil24 does not work for me.
> This is still the same with 2.6.33-rc2.
> 
> Why I think, this might be a problem within libata:
>  * other drivers can use MSI successful on my system (tg3, radeon, hda-intel)
>  * happens both in sata_sil24 and sata_nv
>  * the count in /proc/interrupts increases for the MSIs assigned to
> sata_sil24/sata_nv, so interrupt delivery seems to work
>  * only writing seems to fail

How does it fail?  Timeouts?  Also, ahci enables MSI by default if
available and works fine on many configurations so I don't think
anything in libata core layer is broken regarding MSI (there just
isn't anything which can break).

Thanks.

-- 
tejun
