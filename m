Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZKQAwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZKQAwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZKQAwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:52:49 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:38143 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZKQAwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:52:47 -0500
Message-ID: <4B01F3D9.5090003@ahsoftware.de>
Date: Tue, 17 Nov 2009 01:52:41 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <4AFDED47.5070606@ahsoftware.de> <4AFE1B0D.3060404@ahsoftware.de> <200911141106.51948.oliver@neukum.org> <4AFEE981.8060505@ahsoftware.de> <4B01EC11.4030901@ahsoftware.de>
In-Reply-To: <4B01EC11.4030901@ahsoftware.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 17.11.2009 01:19, schrieb Alexander Holler:
> shame on me. Sorry, I wasn't aware the logger (with default
> configuration) of the system in question doesn't log every kernel
> message. I've just started another rsync after  I've changed that.

Here it is, I haven't cut anything in between and have choosen some 
lines (of the 1gb-log I've got) before and after the first reset-message:

--------------------------------------------------
Nov 17 01:14:50 krabat kernel: [ 1219.910972] usb-storage: Bulk command 
transfer result=0
Nov 17 01:14:50 krabat kernel: [ 1219.910975] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 122880 bytes, 18 entries
Nov 17 01:14:50 krabat kernel: [ 1219.919173] ehci_hcd 0000:00:1d.7: 
port 1 high speed
Nov 17 01:14:50 krabat kernel: [ 1219.919180] ehci_hcd 0000:00:1d.7: 
GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
Nov 17 01:14:50 krabat kernel: [ 1219.937890] usb-storage: Status code 
0; transferred 122880/122880
Nov 17 01:14:50 krabat kernel: [ 1219.937893] usb-storage: -- transfer 
complete
Nov 17 01:14:50 krabat kernel: [ 1219.937896] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:14:50 krabat kernel: [ 1219.937898] usb-storage: Attempting to 
get CSW...
Nov 17 01:14:50 krabat kernel: [ 1219.937900] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:14:55 krabat kernel: [ 1224.973594] usb 3-1: usb-storage timed 
out on ep0out len=0/0
Nov 17 01:14:55 krabat kernel: [ 1224.973718] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:14:55 krabat kernel: [ 1224.973721] usb-storage: -- transfer 
complete
Nov 17 01:14:55 krabat kernel: [ 1224.973723] usb-storage: Bulk status 
result = 0
Nov 17 01:14:55 krabat kernel: [ 1224.973726] usb-storage: Bulk Status S 
0x53425355 T 0x72e1e R 0 Stat 0x0
Nov 17 01:14:55 krabat kernel: [ 1224.973729] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:14:55 krabat kernel: [ 1224.973733] usb-storage: *** thread 
sleeping.
Nov 17 01:14:55 krabat kernel: [ 1224.973753] usb-storage: queuecommand 
called
Nov 17 01:14:55 krabat kernel: [ 1224.973766] usb-storage: *** thread 
awakened.
Nov 17 01:14:55 krabat kernel: [ 1224.973770] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:14:55 krabat kernel: [ 1224.973772] usb-storage:  28 00 20 c5 
40 da 00 00 10 00
Nov 17 01:14:55 krabat kernel: [ 1224.973785] usb-storage: Bulk Command 
S 0x43425355 T 0x72e1f L 8192 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:14:55 krabat kernel: [ 1224.973790] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:14:55 krabat kernel: [ 1224.997517] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:14:55 krabat kernel: [ 1224.997520] usb-storage: -- transfer 
complete
Nov 17 01:14:55 krabat kernel: [ 1224.997522] usb-storage: Bulk command 
transfer result=0
Nov 17 01:14:55 krabat kernel: [ 1224.997525] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 8192 bytes, 2 entries
Nov 17 01:14:55 krabat kernel: [ 1225.021720] usb-storage: Status code 
0; transferred 8192/8192
Nov 17 01:14:55 krabat kernel: [ 1225.021722] usb-storage: -- transfer 
complete
Nov 17 01:14:55 krabat kernel: [ 1225.021725] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:14:55 krabat kernel: [ 1225.021727] usb-storage: Attempting to 
get CSW...
Nov 17 01:14:55 krabat kernel: [ 1225.021729] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:15:00 krabat kernel: [ 1230.175844] usb 3-1: usb-storage timed 
out on ep0out len=0/0
Nov 17 01:15:00 krabat kernel: [ 1230.175958] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:15:00 krabat kernel: [ 1230.175961] usb-storage: -- transfer 
complete
Nov 17 01:15:00 krabat kernel: [ 1230.175963] usb-storage: Bulk status 
result = 0
Nov 17 01:15:00 krabat kernel: [ 1230.175966] usb-storage: Bulk Status S 
0x53425355 T 0x72e1f R 0 Stat 0x0
Nov 17 01:15:00 krabat kernel: [ 1230.175969] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:15:00 krabat kernel: [ 1230.175973] usb-storage: *** thread 
sleeping.
Nov 17 01:15:00 krabat kernel: [ 1230.175990] usb-storage: queuecommand 
called
Nov 17 01:15:00 krabat kernel: [ 1230.176001] usb-storage: *** thread 
awakened.
Nov 17 01:15:00 krabat kernel: [ 1230.176006] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:15:00 krabat kernel: [ 1230.176009] usb-storage:  28 00 20 c5 
40 ea 00 00 f0 00
Nov 17 01:15:00 krabat kernel: [ 1230.176021] usb-storage: Bulk Command 
S 0x43425355 T 0x72e20 L 122880 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:15:00 krabat kernel: [ 1230.176026] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:15:00 krabat kernel: [ 1230.199896] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:15:00 krabat kernel: [ 1230.199899] usb-storage: -- transfer 
complete
Nov 17 01:15:00 krabat kernel: [ 1230.199901] usb-storage: Bulk command 
transfer result=0
Nov 17 01:15:00 krabat kernel: [ 1230.199904] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 122880 bytes, 14 entries
Nov 17 01:15:00 krabat kernel: [ 1230.226621] usb-storage: Status code 
0; transferred 122880/122880
Nov 17 01:15:00 krabat kernel: [ 1230.226624] usb-storage: -- transfer 
complete
Nov 17 01:15:00 krabat kernel: [ 1230.226627] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:15:00 krabat kernel: [ 1230.226629] usb-storage: Attempting to 
get CSW...
Nov 17 01:15:00 krabat kernel: [ 1230.226631] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:15:01 krabat kernel: [ 1230.379301] usb 3-1: device not 
accepting address 4, error -110
Nov 17 01:15:01 krabat kernel: [ 1230.435354] ehci_hcd 0000:00:1d.7: 
port 1 high speed
Nov 17 01:15:01 krabat kernel: [ 1230.435361] ehci_hcd 0000:00:1d.7: 
GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
Nov 17 01:15:01 krabat kernel: [ 1230.491016] usb 3-1: reset high speed 
USB device using ehci_hcd and address 4
Nov 17 01:15:06 krabat kernel: [ 1235.489802] usb 3-1: usb-storage timed 
out on ep0in len=0/64
Nov 17 01:15:06 krabat kernel: [ 1235.489907] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:15:06 krabat kernel: [ 1235.489909] usb-storage: -- transfer 
complete
Nov 17 01:15:06 krabat kernel: [ 1235.489912] usb-storage: Bulk status 
result = 0
Nov 17 01:15:06 krabat kernel: [ 1235.489915] usb-storage: Bulk Status S 
0x53425355 T 0x72e20 R 0 Stat 0x0
Nov 17 01:15:06 krabat kernel: [ 1235.489918] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:15:06 krabat kernel: [ 1235.489922] usb-storage: *** thread 
sleeping.
Nov 17 01:15:06 krabat kernel: [ 1235.489942] usb-storage: queuecommand 
called
Nov 17 01:15:06 krabat kernel: [ 1235.489954] usb-storage: *** thread 
awakened.
Nov 17 01:15:06 krabat kernel: [ 1235.489958] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:15:06 krabat kernel: [ 1235.489961] usb-storage:  28 00 20 c5 
41 da 00 00 10 00
Nov 17 01:15:06 krabat kernel: [ 1235.489974] usb-storage: Bulk Command 
S 0x43425355 T 0x72e21 L 8192 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:15:06 krabat kernel: [ 1235.489979] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:15:06 krabat kernel: [ 1235.513844] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:15:06 krabat kernel: [ 1235.513847] usb-storage: -- transfer 
complete
Nov 17 01:15:06 krabat kernel: [ 1235.513850] usb-storage: Bulk command 
transfer result=0
Nov 17 01:15:06 krabat kernel: [ 1235.513853] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 8192 bytes, 1 entries
Nov 17 01:15:06 krabat kernel: [ 1235.515203] usb-storage: Status code 
0; transferred 8192/8192
Nov 17 01:15:06 krabat kernel: [ 1235.515205] usb-storage: -- transfer 
complete
Nov 17 01:15:06 krabat kernel: [ 1235.515208] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:15:06 krabat kernel: [ 1235.515209] usb-storage: Attempting to 
get CSW...
Nov 17 01:15:06 krabat kernel: [ 1235.515212] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:15:06 krabat kernel: [ 1235.537775] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:15:06 krabat kernel: [ 1235.537778] usb-storage: -- transfer 
complete
Nov 17 01:15:06 krabat kernel: [ 1235.537780] usb-storage: Bulk status 
result = 0
Nov 17 01:15:06 krabat kernel: [ 1235.537783] usb-storage: Bulk Status S 
0x53425355 T 0x72e21 R 0 Stat 0x0
Nov 17 01:15:06 krabat kernel: [ 1235.537786] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:15:06 krabat kernel: [ 1235.537790] usb-storage: *** thread 
sleeping.
Nov 17 01:15:06 krabat kernel: [ 1235.537808] usb-storage: queuecommand 
called
Nov 17 01:15:06 krabat kernel: [ 1235.537819] usb-storage: *** thread 
awakened.
Nov 17 01:15:06 krabat kernel: [ 1235.537823] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:15:06 krabat kernel: [ 1235.537826] usb-storage:  28 00 20 c5 
41 ea 00 00 f0 00
Nov 17 01:15:06 krabat kernel: [ 1235.537839] usb-storage: Bulk Command 
S 0x43425355 T 0x72e22 L 122880 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:15:06 krabat kernel: [ 1235.537844] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:15:06 krabat kernel: [ 1235.561711] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:15:06 krabat kernel: [ 1235.561714] usb-storage: -- transfer 
complete
Nov 17 01:15:06 krabat kernel: [ 1235.561716] usb-storage: Bulk command 
transfer result=0
Nov 17 01:15:06 krabat kernel: [ 1235.561719] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 122880 bytes, 19 entries
Nov 17 01:15:06 krabat kernel: [ 1235.569776] ehci_hcd 0000:00:1d.7: 
port 1 high speed
Nov 17 01:15:06 krabat kernel: [ 1235.569782] ehci_hcd 0000:00:1d.7: 
GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
Nov 17 01:15:06 krabat kernel: [ 1235.588475] usb-storage: Status code 
0; transferred 122880/122880
Nov 17 01:15:06 krabat kernel: [ 1235.588478] usb-storage: -- transfer 
complete
Nov 17 01:15:06 krabat kernel: [ 1235.588481] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:15:06 krabat kernel: [ 1235.588483] usb-storage: Attempting to 
get CSW...
Nov 17 01:15:06 krabat kernel: [ 1235.588486] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:15:11 krabat kernel: [ 1240.624209] usb 3-1: usb-storage timed 
out on ep0out len=0/0
Nov 17 01:15:11 krabat kernel: [ 1240.624332] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:15:11 krabat kernel: [ 1240.624335] usb-storage: -- transfer 
complete
Nov 17 01:15:11 krabat kernel: [ 1240.624337] usb-storage: Bulk status 
result = 0
Nov 17 01:15:11 krabat kernel: [ 1240.624340] usb-storage: Bulk Status S 
0x53425355 T 0x72e22 R 0 Stat 0x0
Nov 17 01:15:11 krabat kernel: [ 1240.624343] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:15:11 krabat kernel: [ 1240.624347] usb-storage: *** thread 
sleeping.
Nov 17 01:15:11 krabat kernel: [ 1240.624368] usb-storage: queuecommand 
called
Nov 17 01:15:11 krabat kernel: [ 1240.624382] usb-storage: *** thread 
awakened.
Nov 17 01:15:11 krabat kernel: [ 1240.624386] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:15:11 krabat kernel: [ 1240.624388] usb-storage:  28 00 20 c5 
42 da 00 00 10 00
Nov 17 01:15:11 krabat kernel: [ 1240.624401] usb-storage: Bulk Command 
S 0x43425355 T 0x72e23 L 8192 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:15:11 krabat kernel: [ 1240.624407] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:15:11 krabat kernel: [ 1240.648270] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:15:11 krabat kernel: [ 1240.648274] usb-storage: -- transfer 
complete
Nov 17 01:15:11 krabat kernel: [ 1240.648276] usb-storage: Bulk command 
transfer result=0
Nov 17 01:15:11 krabat kernel: [ 1240.648279] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 8192 bytes, 2 entries
Nov 17 01:15:11 krabat kernel: [ 1240.672332] usb-storage: Status code 
0; transferred 8192/8192
Nov 17 01:15:11 krabat kernel: [ 1240.672335] usb-storage: -- transfer 
complete
Nov 17 01:15:11 krabat kernel: [ 1240.672338] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:15:11 krabat kernel: [ 1240.672340] usb-storage: Attempting to 
get CSW...
Nov 17 01:15:11 krabat kernel: [ 1240.672343] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:15:16 krabat kernel: [ 1245.826495] usb 3-1: usb-storage timed 
out on ep0out len=0/0
Nov 17 01:15:16 krabat kernel: [ 1245.826550] usb-storage: Status code 
0; transferred 13/13
Nov 17 01:15:16 krabat kernel: [ 1245.826552] usb-storage: -- transfer 
complete
Nov 17 01:15:16 krabat kernel: [ 1245.826555] usb-storage: Bulk status 
result = 0
Nov 17 01:15:16 krabat kernel: [ 1245.826557] usb-storage: Bulk Status S 
0x53425355 T 0x72e23 R 0 Stat 0x0
Nov 17 01:15:16 krabat kernel: [ 1245.826561] usb-storage: scsi cmd 
done, result=0x0
Nov 17 01:15:16 krabat kernel: [ 1245.826564] usb-storage: *** thread 
sleeping.
Nov 17 01:15:16 krabat kernel: [ 1245.826581] usb-storage: queuecommand 
called
Nov 17 01:15:16 krabat kernel: [ 1245.826593] usb-storage: *** thread 
awakened.
Nov 17 01:15:16 krabat kernel: [ 1245.826597] usb-storage: Command 
READ_10 (10 bytes)
Nov 17 01:15:16 krabat kernel: [ 1245.826600] usb-storage:  28 00 20 c5 
42 ea 00 00 f0 00
Nov 17 01:15:16 krabat kernel: [ 1245.826613] usb-storage: Bulk Command 
S 0x43425355 T 0x72e24 L 122880 F 128 Trg 0 LUN 0 CL 10
Nov 17 01:15:16 krabat kernel: [ 1245.826617] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 31 bytes
Nov 17 01:15:16 krabat kernel: [ 1245.850498] usb-storage: Status code 
0; transferred 31/31
Nov 17 01:15:16 krabat kernel: [ 1245.850501] usb-storage: -- transfer 
complete
Nov 17 01:15:16 krabat kernel: [ 1245.850504] usb-storage: Bulk command 
transfer result=0
Nov 17 01:15:16 krabat kernel: [ 1245.850507] usb-storage: 
usb_stor_bulk_transfer_sglist: xfer 122880 bytes, 23 entries
Nov 17 01:15:16 krabat kernel: [ 1245.877356] usb-storage: Status code 
0; transferred 122880/122880
Nov 17 01:15:16 krabat kernel: [ 1245.877360] usb-storage: -- transfer 
complete
Nov 17 01:15:16 krabat kernel: [ 1245.877362] usb-storage: Bulk data 
transfer result 0x0
Nov 17 01:15:16 krabat kernel: [ 1245.877364] usb-storage: Attempting to 
get CSW...
Nov 17 01:15:16 krabat kernel: [ 1245.877367] usb-storage: 
usb_stor_bulk_transfer_buf: xfer 13 bytes
Nov 17 01:15:16 krabat kernel: [ 1246.029964] usb 3-1: device not 
accepting address 4, error -110
Nov 17 01:15:16 krabat kernel: [ 1246.086081] ehci_hcd 0000:00:1d.7: 
port 1 high speed
Nov 17 01:15:16 krabat kernel: [ 1246.086088] ehci_hcd 0000:00:1d.7: 
GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
--------------------------------------------------

If more infos are needed (or the complete log)...

Regards,

Alexander
