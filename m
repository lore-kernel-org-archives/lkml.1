Return-Path: <linux-kernel-owner+w=401wt.eu-S1765361AbXJTGb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765361AbXJTGb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXJTGbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:31:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34200 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbXJTGbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:31:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4719A0C4.3050301@s5r6.in-berlin.de>
Date: Sat, 20 Oct 2007 08:31:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de>	<m34pgpmszu.fsf@maximus.localdomain>	<47166C83.2050207@s5r6.in-berlin.de> <m3fy09ffp9.fsf@maximus.localdomain>
In-Reply-To: <m3fy09ffp9.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> OTOH, it's no magic - they claim OHCI 1.1 and they do it. We don't
> only know how to enable it with (only) software. I suspect all those
> VT6306 could be "upgraded" as well.

What if we add a whitelisting in the driver which ignores the register
contents which state OHCI 1.0 implementation level, and just treats
these VIA chips as OHCI 1.1 implementations?
-- 
Stefan Richter
-=====-=-=== =-=- =-=--
http://arcgraph.de/sr/
