Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZKQBLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZKQBLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZKQBLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:11:30 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:55214 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZKQBLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:11:30 -0500
Message-ID: <4B01F83E.5040905@ahsoftware.de>
Date: Tue, 17 Nov 2009 02:11:26 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <4AFDED47.5070606@ahsoftware.de> <4AFE1B0D.3060404@ahsoftware.de> <200911141106.51948.oliver@neukum.org> <4AFEE981.8060505@ahsoftware.de> <4B01EC11.4030901@ahsoftware.de> <4B01F3D9.5090003@ahsoftware.de>
In-Reply-To: <4B01F3D9.5090003@ahsoftware.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't my time, :(

Am 17.11.2009 01:52, schrieb Alexander Holler:
> Here it is, I haven't cut anything in between and have choosen some
> lines (of the 1gb-log I've got) before and after the first reset-message:
>
> --------------------------------------------------
> Nov 17 01:14:50 krabat kernel: [ 1219.910972] usb-storage: Bulk command
> transfer result=0

that was the second reset message, here is the first:

------------------------
Nov 17 01:14:14 krabat kernel: [ 1184.253782] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:14:14 krabat kernel: [ 1184.253784] usb-storage: Attempting to 
get CSW...
Nov 17 01:14:14 krabat kernel: [ 1184.253786] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:14:14 krabat kernel: [ 1184.253795] usb-storage: Status code 
0; transferred 8192/8192
Nov 17 01:14:14 krabat kernel: [ 1184.253797] usb-storage: -- transfer 
complete
Nov 17 01:14:14 krabat kernel: [ 1184.253799] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:14:14 krabat kernel: [ 1184.253801] usb-storage: Attempting to 
get CSW...
Nov 17 01:14:14 krabat kernel: [ 1184.253804] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:14:45 krabat kernel: [ 1214.716721] usb-storage: command_abort 
called
Nov 17 01:14:45 krabat kernel: [ 1214.716725] usb-storage: 
usb_stor_stop_transport called
Nov 17 01:14:45 krabat kernel: [ 1214.716727] usb-storage: -- cancelling URB
Nov 17 01:14:45 krabat kernel: [ 1214.728631] usb-storage: Status code 
-104; transferred 0/13
Nov 17 01:14:45 krabat kernel: [ 1214.728634] usb-storage: -- transfer 
cancelled
Nov 17 01:14:45 krabat kernel: [ 1214.728637] usb-storage: Bulk status 
result = 4
Nov 17 01:14:45 krabat kernel: [ 1214.728639] usb-storage: -- command 
was aborted
Nov 17 01:14:45 krabat kernel: [ 1214.728643] usb-storage: 
usb_stor_pre_reset
Nov 17 01:14:45 krabat kernel: [ 1214.728738] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:14:45 krabat kernel: [ 1214.728741] usb-storage: -- transfer 
complete
Nov 17 01:14:45 krabat kernel: [ 1214.728743] usb-storage: Bulk status 
result = 0
Nov 17 01:14:45 krabat kernel: [ 1214.728746] usb-storage: Bulk Status S 
0x53425355 T 0x72e1b R 0 Stat 0x0
Nov 17 01:14:45 krabat kernel: [ 1214.728750] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:14:45 krabat kernel: [ 1214.728754] usb-storage: *** thread 
sleeping.
Nov 17 01:14:45 krabat kernel: [ 1214.728772] usb-storage: queuecommand 
called
Nov 17 01:14:45 krabat kernel: [ 1214.728784] usb-storage: *** thread 
awakened.
Nov 17 01:14:45 krabat kernel: [ 1214.728788] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:14:45 krabat kernel: [ 1214.728790] usb-storage:  28 00 20 c5 
3e ea 00 00 f0 00
Nov 17 01:14:45 krabat kernel: [ 1214.728804] usb-storage: Bulk Command 
S 0x43425355 T 0x72e1c L 122880 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:14:45 krabat kernel: [ 1214.728809] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:14:45 krabat kernel: [ 1214.752624] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:14:45 krabat kernel: [ 1214.752627] usb-storage: -- transfer 
complete
Nov 17 01:14:45 krabat kernel: [ 1214.752629] usb-storage: Bulk command 
transfer result=0
Nov 17 01:14:45 krabat kernel: [ 1214.752633] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 122880 bytes, 8 entries
Nov 17 01:14:45 krabat kernel: [ 1214.779473] usb-storage: Status code 
0; transferred 122880/122880
Nov 17 01:14:45 krabat kernel: [ 1214.779476] usb-storage: -- transfer 
complete
Nov 17 01:14:45 krabat kernel: [ 1214.779478] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:14:45 krabat kernel: [ 1214.779480] usb-storage: Attempting to 
get CSW...
Nov 17 01:14:45 krabat kernel: [ 1214.779483] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:14:45 krabat kernel: [ 1214.784753] ehci_hcd 0000:00:1d.7: 
port 1 high speed
Nov 17 01:14:45 krabat kernel: [ 1214.784760] ehci_hcd 0000:00:1d.7: 
GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
Nov 17 01:14:45 krabat kernel: [ 1214.840337] usb 3-1: reset high speed 
USB device using ehci_hcd and address 4
Nov 17 01:14:50 krabat kernel: [ 1219.839123] usb 3-1: usb-storage timed 
out on ep0in len=0/64
Nov 17 01:14:50 krabat kernel: [ 1219.839213] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:14:50 krabat kernel: [ 1219.839216] usb-storage: -- transfer 
complete
Nov 17 01:14:50 krabat kernel: [ 1219.839218] usb-storage: Bulk status 
result = 0
Nov 17 01:14:50 krabat kernel: [ 1219.839221] usb-storage: Bulk Status S 
0x53425355 T 0x72e1c R 0 Stat 0x0
Nov 17 01:14:50 krabat kernel: [ 1219.839225] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:14:50 krabat kernel: [ 1219.839229] usb-storage: *** thread 
sleeping.
Nov 17 01:14:50 krabat kernel: [ 1219.839250] usb-storage: queuecommand 
called
Nov 17 01:14:50 krabat kernel: [ 1219.839263] usb-storage: *** thread 
awakened.
Nov 17 01:14:50 krabat kernel: [ 1219.839267] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:14:50 krabat kernel: [ 1219.839270] usb-storage:  28 00 20 c5 
3f da 00 00 10 00
Nov 17 01:14:50 krabat kernel: [ 1219.839283] usb-storage: Bulk Command 
S 0x43425355 T 0x72e1d L 8192 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:14:50 krabat kernel: [ 1219.839288] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:14:50 krabat kernel: [ 1219.863238] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:14:50 krabat kernel: [ 1219.863241] usb-storage: -- transfer 
complete
Nov 17 01:14:50 krabat kernel: [ 1219.863243] usb-storage: Bulk command 
transfer result=0
Nov 17 01:14:50 krabat kernel: [ 1219.863246] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 8192 bytes, 2 entries
Nov 17 01:14:50 krabat kernel: [ 1219.864602] usb-storage: Status code 
0; transferred 8192/8192
Nov 17 01:14:50 krabat kernel: [ 1219.864605] usb-storage: -- transfer 
complete
Nov 17 01:14:50 krabat kernel: [ 1219.864607] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:14:50 krabat kernel: [ 1219.864609] usb-storage: Attempting to 
get CSW...
Nov 17 01:14:50 krabat kernel: [ 1219.864612] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:14:50 krabat kernel: [ 1219.887021] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:14:50 krabat kernel: [ 1219.887024] usb-storage: -- transfer 
complete
Nov 17 01:14:50 krabat kernel: [ 1219.887027] usb-storage: Bulk status 
result = 0
Nov 17 01:14:50 krabat kernel: [ 1219.887030] usb-storage: Bulk Status S 
0x53425355 T 0x72e1d R 0 Stat 0x0
Nov 17 01:14:50 krabat kernel: [ 1219.887033] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:14:50 krabat kernel: [ 1219.887037] usb-storage: *** thread 
sleeping.
Nov 17 01:14:50 krabat kernel: [ 1219.887053] usb-storage: queuecommand 
called
Nov 17 01:14:50 krabat kernel: [ 1219.887064] usb-storage: *** thread 
awakened.
Nov 17 01:14:50 krabat kernel: [ 1219.887068] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:14:50 krabat kernel: [ 1219.887071] usb-storage:  28 00 20 c5 
3f ea 00 00 f0 00
Nov 17 01:14:50 krabat kernel: [ 1219.887083] usb-storage: Bulk Command 
S 0x43425355 T 0x72e1e L 122880 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:14:50 krabat kernel: [ 1219.887089] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:14:50 krabat kernel: [ 1219.910966] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:14:50 krabat kernel: [ 1219.910969] usb-storage: -- transfer 
complete
Nov 17 01:14:50 krabat kernel: [ 1219.910972] usb-storage: Bulk command 
transfer result=0
> --------------------------------------------------
>
> If more infos are needed (or the complete log)...
>
> Regards,
>
> Alexander
