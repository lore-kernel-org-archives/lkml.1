Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbXGEQXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbXGEQXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbXGEQXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:23:34 -0400
Received: from relay2.belkam.com ([87.249.237.18]:55984 "EHLO
	relay2.belkam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbXGEQXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:23:33 -0400
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 12:23:33 EDT
Message-ID: <468D1344.30007@belkam.com>
Date: Thu, 05 Jul 2007 20:50:28 +0500
From: Dmitry Melekhov <dm@belkam.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070421)
MIME-Version: 1.0
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: scsi lun online resize
References: <46652EB3.4060903@belkam.com> <20070705125951.GF4106@edu.joroinen.fi>
In-Reply-To: <20070705125951.GF4106@edu.joroinen.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Antivirus: avast! (VPS 000754-1, 04.07.2007), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pasi Kärkkäinen wrote:
> On Tue, Jun 05, 2007 at 02:36:51PM +0500, Dmitry Melekhov wrote:
>   
>> Hello!
>>
>> I'm playing with iscsi on linux.
>> And I have following problem:
>>
>> If I change lun size on target side and then do echo "1" >/sys/block/
>> sdb/device/rescan
>> device size is changed only if /dev/sdb is not mounted, if it is
>> mounted fdisk shows no size change, so lun can't be resized online.
>>
>> open-iscsi guys say this is general linux problem, not iscsi specific.
>> Could you tell me is there any solution?
>>
>>     
>
> Do you have partition table on /dev/sdb, or are you using /dev/sdb directly? 
>
>
>   
I tried both...



