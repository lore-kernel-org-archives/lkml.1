Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZGBNXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZGBNXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGBNXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:23:00 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:4552 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZGBNW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:22:59 -0400
Message-ID: <4A4CB4B4.5010307@turknet.net.tr>
Date: Thu, 02 Jul 2009 16:23:00 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1pre) Gecko/20090701 Shredder/3.0b3pre
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 13:23:00.0739 (UTC) FILETIME=[38CB1530:01C9FB18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just compiled 2.6.31-rc1-git9 to give it a try. The problem I 
encountered with this release is that it cannot recognize empty DVD 
(probably CD will be the same. But, I didn't try it.) media with K3b. 
I'm having the below error messages in dmesg. Also, I tried with several 
new empty DVD medias. So, I'm sure that it's not a faulty DVD media. The 
same media burns fine with K3b under <= 2.6.31-rc1-git6.


[ 4526.724245] cdrom: This disc doesn't have any tracks I recognize!
[ 4526.748278] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 4526.748285] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
[ 4526.748292] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
[ 4526.748300] end_request: I/O error, dev sr0, sector 0
[ 4526.748307] Buffer I/O error on device sr0, logical block 0
[ 4526.750295] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 4526.750302] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
[ 4526.750308] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
[ 4526.750316] end_request: I/O error, dev sr0, sector 0
[ 4526.750321] Buffer I/O error on device sr0, logical block 0
[ 4586.738212] cdrom: This disc doesn't have any tracks I recognize!
[ 4586.753644] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 4586.753652] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
[ 4586.753659] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
[ 4586.753668] end_request: I/O error, dev sr0, sector 0
[ 4586.753673] Buffer I/O error on device sr0, logical block 0
[ 4586.757373] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 4586.757379] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
[ 4586.757384] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
[ 4586.757391] end_request: I/O error, dev sr0, sector 0
[ 4586.757395] Buffer I/O error on device sr0, logical block 0


Tarkan
