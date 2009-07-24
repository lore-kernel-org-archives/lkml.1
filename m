Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZGXLo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZGXLo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 07:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZGXLo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 07:44:57 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:23754 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZGXLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 07:44:56 -0400
Message-ID: <4A699EB7.4030307@turknet.net.tr>
Date: Fri, 24 Jul 2009 14:44:55 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2pre) Gecko/20090723 Shredder/3.0b4pre
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
CC: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
In-Reply-To: <4A69932E.90906@turknet.net.tr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 11:44:56.0169 (UTC) FILETIME=[2A677590:01CA0C54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2009 01:55 PM, Tarkan Erimer wrote:
>
> Martin,
>
> Today, I had time to bisect and you were right: The below commit 
> related to capacity detection changes in SCSI subsystem,as you 
> mentioned, seems the cause of the problem.
>

Sorry, I was confused when replying. The introduced bug is not because 
of the "Capacity Detection Changes In SCSI Subsystem." commit; because 
of "sd: Detect non-rotational devices" commit. It seems I need more 
coffee ;-)
One more time sorry for my stupidity :-)


> 3821d768912a47ddbd6cab52943a8284df88003c is first bad commit
> commit 3821d768912a47ddbd6cab52943a8284df88003c
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Sat May 23 11:43:38 2009 -0400
>
>     sd: Detect non-rotational devices
>
>     Detect non-rotational devices and set the queue flag accordingly.
>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>     Signed-off-by: James Bottomley 
> <James.Bottomley@HansenPartnership.com>
>
> :040000 040000 f744f08d73f56e6d8461267c8c5bc4c710d4c9dd 
> 89eb1f56a7066a22a9ae6b7b916453a78a9dd082 M      drivers
>
>

