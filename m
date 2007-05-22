Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbXEVM1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbXEVM1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXEVM1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:27:44 -0400
Received: from cnxtsmtp5.conexant.com ([198.62.9.40]:57860 "EHLO
	cnxtsmtp5.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbXEVM1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:27:43 -0400
X-WSS-ID: 0JIFZYG-02-3UP-02
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: bulk transfer bits-per-second calculation for RNDIS/USB
Date: Tue, 22 May 2007 17:57:38 +0530
Message-ID: <1DF8CECB8B125247ADB23FC01CC3570E46B75C@NOIDA-MAIL2.bbnet.ad>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bulk transfer bits-per-second calculation for RNDIS/USB
Thread-Index: AcecbJW0TDrekO65TneFIAPi+h+UEA==
From: "Joji Joseph" <Joji.Joseph@conexant.com>
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 22 May 2007 12:27:42.0427 (UTC) FILETIME=[9805DAB0:01C79C6C]
X-TM-AS-Product-Ver: SMEX-7.0.0.1499-3.6.1039-15190.003
X-TM-AS-Result: No--2.938500-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

 I have seen a peak bulk transfer bits-per-second calculation in the
"usb/gadget/ether.c" file as given below,
 #define        HS_BPS          (13 * 512 * 8 * 1000 * 8)
 #define        FS_BPS          (19 *  64 * 1 * 1000 * 8)

Could any RNDIS/USB experts help me to understand how this calculation
had come up and what are the components which get multiplied here for
the full/high speed bits per second?

Thanks in advance for the help.

Regards,
Joji


Conexant E-mail Firewall (Conexant.Com) made the following annotations---------------------------------------------------------------------********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------
