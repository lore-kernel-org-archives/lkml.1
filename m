Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYB0N2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYB0N2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYB0N2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:28:33 -0500
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:40102 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbYB0N2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:28:33 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 08:28:32 EST
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:Received:
   Message-ID:Date:From:Organization:User-Agent:MIME-Version:
   To:Subject:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=bo2xDoZdno+iyAbi3CKkoJ7A9rMKYlUXlKHogg83AOuHDzT6xxyAoDPT
   q0dTTH/z6Au4QRmZWmZDPnFZETUAEIuvud6Pr6LqfSrRqJP9zcQeE+9JD
   4dzxCTHylW8igZy;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.25,412,1199660400"; 
   d="scan'208";a="29884502"
Message-ID: <47C5632B.7030402@fujitsu-siemens.com>
Date: Wed, 27 Feb 2008 14:18:35 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: idle_notifier_unregister()
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas, hello Ingo,

Your commit a72368dd37f6ae333fbab03598e46a995d91decc "x86: remove dead
code and exports" removes the function idle_notifier_unregister().
Please restore this function. I have a driver here which wouldn't unload
cleanly if this function is unavailable.

What's the point in removing the idle_notifier_unregister() function
while keeping idle_notifier_register()? Is the idle_notifier API a
one-way API by design?

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20209
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
