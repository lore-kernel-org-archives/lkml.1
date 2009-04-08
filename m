Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbZDHKdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbZDHKdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbZDHKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:33:32 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:48844 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbZDHKdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:33:31 -0400
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 06:33:30 EDT
From: Mikael Starvik <mikael.starvik@axis.com>
To: Claudio Scordino <claudio@evidence.eu.com>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>
Date: Wed, 8 Apr 2009 12:12:33 +0200
Subject: RE: [PATCH] Fix broken compilation of Cris serial driver
Thread-Topic: [PATCH] Fix broken compilation of Cris serial driver
Thread-Index: Acm4Mffulb1Z8v/XTHuiUpoNJx9nMAAAH6wA
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D053B06F59AF3@xmail3.se.axis.com>
References: <49DC7754.4030404@evidence.eu.com>
In-Reply-To: <49DC7754.4030404@evidence.eu.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks ok, go ahead and commit!

Thanks
/Mikael

-----Original Message-----
From: Claudio Scordino [mailto:claudio@evidence.eu.com] 
Sent: den 8 april 2009 12:07
To: Jesper Nilsson; Mikael Starvik
Cc: Alan Cox; Hinko Kocevar; Janez Cufer; Andrew Morton; Linux Kernel; dev-etrax; adobriyan@gmail.com
Subject: [PATCH] Fix broken compilation of Cris serial driver

Hi,

    compilation of cris serial driver on 2.6.30-rc1 is broken since commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the read_proc field from the tty_driver structure.

The patch in attachment may fix the problem. Please check it very
carefully: I don't have hardware to make any test.

Regards,

           Claudio
