Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYJ2CG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYJ2CG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYJ2CGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:06:19 -0400
Received: from gw2.scei.a-star.edu.sg ([192.122.140.11]:43626 "EHLO
	gw2.scei.a-star.edu.sg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYJ2CGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:06:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: UWB, WUSB, and WLP subsystems for 2.6.28
Date: Wed, 29 Oct 2008 10:05:52 +0800
Message-ID: <162B8AFBFBBB2148A9A1B8F9C5753428057B9D55@mailbe01.teak.local.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: UWB, WUSB, and WLP subsystems for 2.6.28
Thread-Index: Ack07e3s/h2fDgRBSNS5fq0hME3uUAEfAPNN
References: <fa.s78bJIT7sRB89tYmSVZWUEBUq5k@ifi.uio.no> <6f3df9eb-5c1a-4ee1-a78f-7c0ff55a42fc@t18g2000prt.googlegroups.com> <49003D45.4080708@csr.com>
From: "Law Sie Yong" <sylaw@i2r.a-star.edu.sg>
To: "David Vrabel" <david.vrabel@csr.com>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Oct 2008 02:05:53.0187 (UTC) FILETIME=[DF441F30:01C9396A]
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.7400:2.4.4,1.2.40,4.0.166 definitions=2008-10-28_08:2008-10-10,2008-10-28,2008-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=5.0.0-0810130000 definitions=main-0810280197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

  Attached below is the error msg i got when trying to enumerate the DLINK WUSB HUB


Oct 29 09:58:46 localhost kernel: wa_notif_dispatch: HWA_NOTIF_DN, device connect 
Oct 29 09:58:46 localhost kernel: #015<6>hwa-hc 1-1:1.0: DN CONNECT: device f9 0c a6 60 83 73 a6 59 c1 ca ed 1c 63 4d 45 9a @ 0 (self-beacon) wants to reconnect
Oct 29 09:58:46 localhost kernel: hwa-hc 1-1:1.0: Connecting new WUSB device to address 130, port 0
Oct 29 09:58:46 localhost kernel: __hwahc_op_dev_info_set: entry
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015<6>hwa-hc 1-1:1.0: device 0: unauth addr 130
Oct 29 09:58:46 localhost kernel: wa_notif_dispatch: HWA_NOTIF_DN, device connect 
Oct 29 09:58:46 localhost kernel: #015<6>hwa-hc 1-1:1.0: DN CONNECT: device f9 0c a6 60 83 73 a6 59 c1 ca ed 1c 63 4d 45 9a @ 0 (self-beacon) wants to reconnect
Oct 29 09:58:46 localhost kernel: __ratelimit: 4 messages suppressed
Oct 29 09:58:46 localhost kernel: hwa-hc 1-1:1.0: Already handling dev f9 0c a6 60 83 73 a6 59 c1 ca ed 1c 63 4d 45 9a  (it might be slow)
Oct 29 09:58:46 localhost kernel: uwbd_dev_onair entry
Oct 29 09:58:46 localhost kernel: #015uwb_dev_add: device name is 00:21:91:1d:4e:c7
Oct 29 09:58:46 localhost kernel: #015uwb_dev f5a23800 parent_dev f6fcec18
Oct 29 09:58:46 localhost kernel: __uwb_dev_sys_add: dev name is 00:21:91:1d:4e:c7
Oct 29 09:58:46 localhost kernel: #015uwb_dev f5a23800 parent_dev f6fcec18) = 0
Oct 29 09:58:46 localhost kernel: uwb_rc uwb0: uwb device (mac 00:21:91:1d:4e:c7 dev 08:5f) connected to usb 1-1:1.1
Oct 29 09:58:46 localhost kernel: uwb_notify: called
Oct 29 09:58:46 localhost kernel: #015wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:46 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:46 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:46 localhost kernel: hwa-hc 1-1:1.0: 40 a7 fa f6 00 10 a4 f8 
Oct 29 09:58:46 localhost kernel: usb 6-1: new variable speed Wireless USB device using hwa-hc and address 2
Oct 29 09:58:46 localhost kernel: hwahc_op_urb_enqueue : entry 
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015wa_urb_enqueue: endpoint address is 0
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015wa_urb_enqueue: endpoint direction is out
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015urb buffer is 80 3b 9c f5 2c 0 9 0 3 e fe 0 fe ff ff 0 8 20 f8 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 ff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
Oct 29 09:58:46 localhost kernel: #015
Oct 29 09:58:46 localhost kernel: #015xfer f59c3b80 urb f59ad500 pipe 0x80000080 [64 bytes] nodma inbound inline
Oct 29 09:58:46 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:46 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:46 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:46 localhost kernel: hwa-hc 1-1:1.0: 40 a7 fa f6 00 10 a4 f8 
Oct 29 09:58:47 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:47 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 44 2d 4c 69 6e 6b 00 00 
Oct 29 09:58:47 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:47 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 44 2d 4c 69 6e 6b 00 00 
Oct 29 09:58:47 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:47 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: c0 58 9e f5 ff ff ff ff 
Oct 29 09:58:47 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:47 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:47 localhost kernel: hwa-hc 1-1:1.0: 80 54 9e f5 ff ff ff ff 
Oct 29 09:58:48 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:48 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:48 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:48 localhost kernel: hwa-hc 1-1:1.0: 40 ad df f6 00 f0 91 f8 
Oct 29 09:58:48 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:48 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:48 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:48 localhost kernel: hwa-hc 1-1:1.0: 80 52 9e f5 08 00 00 00 
Oct 29 09:58:48 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:48 localhost kernel: #015<3>hwa-hc 1-1:1.0: HWA: unknown notification 0x94, 3 bytes; discarding
Oct 29 09:58:48 localhost kernel: hwa-hc 1-1:1.0: 03 94 01 00 00 00 00 00 
Oct 29 09:58:48 localhost kernel: hwa-hc 1-1:1.0: 80 52 9e f5 08 00 00 00 
Oct 29 09:58:48 localhost kernel: wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:49 localhost kernel: #015wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:49 localhost kernel: #015wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:50 localhost kernel: #015wa_notif_dispatch: HWA_NOTIF_BPST_ADJ 
Oct 29 09:58:50 localhost kernel: #015uwb_notify: called
Oct 29 09:58:50 localhost kernel: #015<6> 00:21:91:1d:4e:c7: uwb device (mac 00:21:91:1d:4e:c7 dev 08:5f) disconnected from usb 1-1:1.1
Oct 29 09:58:50 localhost kernel:  00:21:91:1d:4e:c7: uwb_dev_sys_release: uwb_dev f5a23800 freed
Oct 29 09:58:51 localhost kernel: hwahc_op_urb_denqueue : entry 
Oct 29 09:58:51 localhost kernel: #015
Oct 29 09:58:51 localhost kernel: #015xfer f59c3b80#0 ABORTED: result -115

It seems that the DN_CONNECT go thru juzt fine, but when sending urb packet to enumerate the hub (i think ??), there is error in the function __wa_xfer_is_done, case WA_SEG_ABORTED, which cause the abort to occur.BTW, when sending data frame over WUSB to the HUB, just curious if the  endpoint address to be 01 for OUT, instead of 0 (default control endpoint) , as i printed out the value of endpoint address to be 0. thx again for your info !



Law Sie Yong
Senior Research Officer
Communication Systems Department



-----Original Message-----
From: David Vrabel [mailto:david.vrabel@csr.com]
Sent: Thu 10/23/2008 5:00 PM
To: Law Sie Yong
Cc: Kernel development list
Subject: Re: UWB, WUSB, and WLP subsystems for 2.6.28
 
sylaw@i2r.a-star.edu.sg wrote:
> 
>   I am currently working on trying to WUSB linux to work on DLINK
> dub1210 dongle. Does the 2.6.26-rc8 of WUSB UWB linux work with
> DUB1210, as when i try to connect to the DLINK UWB Hub it show me
> error when it try to enumerate the hub i believe. Your help is greatly
> appreciated ! thx in advance !

The WUSB hub (DWA) won't do anything useful because there's no DWA
driver.  However, you should be able to authenticate and enumerate it.

Could you expand on the error messages?  It may be useful to build the
driver with additional debugging.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/

**********************  ANNOUNCEMENT ********************************
 We have moved to Fusionopolis!
 Our official address is:
 Institute for Infocomm Research,  1 Fusionopolis Way,  #21-01 Connexis, South Tower,
 Singapore 138632.   Main line: +65 64082000. Main fax: +65 67761378
 Please visit http://www.fusionopolis.a-star.edu.sg/ for more information
 on Fusionopolis.
******************************************************************

Institute For Infocomm Research - Disclaimer This email is confidential and may be privileged.  If you are not the intended recipient, please delete it and notify us immediately. Please do not copy or use it for any purpose, or disclose its contents to any other person. Thank you."
