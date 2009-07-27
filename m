Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZG0Hb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZG0Hb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZG0Hb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:31:29 -0400
Received: from mail.turknet.net.tr ([193.192.98.182]:53422 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbZG0Hb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:31:28 -0400
Message-ID: <4A6D57CE.3000108@turknet.net.tr>
Date: Mon, 27 Jul 2009 10:31:26 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2pre) Gecko/20090726 Shredder/3.0b4pre
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr> <yq1hbwykj80.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1hbwykj80.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 07:31:27.0349 (UTC) FILETIME=[407AF250:01CA0E8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2009 04:28 AM, Martin K. Petersen wrote:
>>>>>> "Tarkan" == Tarkan Erimer<tarkan.erimer@turknet.net.tr>  writes:
>>>>>>              
> Tarkan>  root@tarkane:~# sg_inq -e /dev/sdb
> Tarkan>  VPD INQUIRY: extended INQUIRY data page
> Tarkan>  inquiry: transport: Host_status=0x05 [DID_ABORT]
> Tarkan>  Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]
> Tarkan>      inquiry: failed, res=-1
>
> *sigh*
>
>
> sd: Avoid sending extended inquiry to legacy/broken devices
>
> Our existing check for VPD page validity does not handle devices that
> refuse to respond to INQUIRY with the EVPD bit set.
>
> Restrict extended inquiry to devices reporting SBC2/SPC3 or higher.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
>
>    

Martin,

Happily, I confirm that your patch worked flawlessly with -rc4! Thanks a 
lot for your help :-)

Cheers!

Tarkan

