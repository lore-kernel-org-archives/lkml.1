Return-Path: <linux-kernel-owner+w=401wt.eu-S937698AbXG0RRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937698AbXG0RRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763162AbXG0RRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:17:34 -0400
Received: from mail42.messagelabs.com ([216.82.244.163]:17937 "HELO
	mail42.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761866AbXG0RRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:17:33 -0400
X-VirusChecked: Checked
X-Env-Sender: subbus@serverengines.com
X-Msg-Ref: server-23.tower-42.messagelabs.com!1185556651!40673362!1
X-StarScan-Version: 5.5.12.11; banners=-,-,-
X-Originating-IP: [66.92.219.162]
To: linux-kernel@vger.kernel.org
From: "Subbu Seetharaman" <subbus@serverengines.com>
Subject: Source organization for two drivers sharing coomon code
Message-ID: <20070727171729.f3ff0878@mailhost.serverengines.com>
Date: Fri, 27 Jul 2007 10:17:29 -0700
X-User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; FunWebProducts; .NET CLR
	1.1.4322)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



What is the recommended way for two drivers to share common code ?
Our device has two PCI functions and hence two drivers -  NIC and 
SCSI driver.   The source code for these dirvers will fit under 
drivers/net and drivers/scsi.  But both drivers share some common 
code.  If possible, I would like to avoid duplicating the common 
code under the two driver directories.   Is there any recommened 
way to organize such common  code ?  Thanks.

Subbu

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines LLC and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

