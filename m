Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYJXC0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYJXC0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 22:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYJXC0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 22:26:34 -0400
Received: from gw2.scei.a-star.edu.sg ([192.122.140.11]:58521 "EHLO
	gw2.scei.a-star.edu.sg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYJXC0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 22:26:33 -0400
X-Greylist: delayed 746 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2008 22:26:33 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: UWB, WUSB, and WLP subsystems for 2.6.28
Date: Fri, 24 Oct 2008 10:13:35 +0800
Message-ID: <162B8AFBFBBB2148A9A1B8F9C5753428057B9D4B@mailbe01.teak.local.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: UWB, WUSB, and WLP subsystems for 2.6.28
Thread-Index: Ack07e3s/h2fDgRBSNS5fq0hME3uUAAj0CxZ
References: <fa.s78bJIT7sRB89tYmSVZWUEBUq5k@ifi.uio.no> <6f3df9eb-5c1a-4ee1-a78f-7c0ff55a42fc@t18g2000prt.googlegroups.com> <49003D45.4080708@csr.com>
From: "Law Sie Yong" <sylaw@i2r.a-star.edu.sg>
To: "David Vrabel" <david.vrabel@csr.com>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Oct 2008 02:13:35.0712 (UTC) FILETIME=[1EE31600:01C9357E]
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.7400:2.4.4,1.2.40,4.0.166 definitions=2008-10-24_01:2008-10-10,2008-10-23,2008-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=5.0.0-0810130000 definitions=main-0810230234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thx for the prompt reply. I will attach the error message soon. BTW, is IOGear Wireless usb dongle (i believe its using Intel i1480 MAC) with RC1.3 firmware confirm to work with the IOGear UWB HUB and be able to detect the mass storage device attached to the hub? or the open source also doesnt have the DWA driver for IOGear HUB?  In addition, i tried to download the UWB for kernel 2.6.28 from git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream, but it doesnt contain any UWB code. i use the "git clone http://www.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream" command to download as i cant use "git clone git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream", error say cant connect.  thx again !







thx again !



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
