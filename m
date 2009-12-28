Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbZL1NBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbZL1NBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 08:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZL1NBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 08:01:44 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39306 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbZL1NBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 08:01:43 -0500
X-Sasl-enc: 74r9gu8XAryc414ILXSYMZiHji0dxOJyaxCYZy0pNzz7 1262005302
Date: Mon, 28 Dec 2009 11:01:38 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, ibm-acpi-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
 shows all the temperatures on thinkpad x60
Message-ID: <20091228130138.GA19362@khazad-dum.debian.net>
References: <20091227215722.GN11737@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227215722.GN11737@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply the latest stack of patches (sent them to acpi-test
yesterday).

It is failing to register the ALSA mixer for some reason, and due
to a bug, it is not loading the module at all.  I will look at the reason it
is failing to register the ALSA mixer soon.  Meanwhile, the patches I sent
to Len make sure the module can still load sucessfully.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
