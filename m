Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXKMQul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXKMQul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbXKMQuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:50:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:52432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbXKMQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:50:31 -0500
Message-ID: <4739D5E1.5060108@anagramm.de>
Date: Tue, 13 Nov 2007 17:50:41 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Florian Boelstler <kernel@boelstler.net>, linux-kernel@vger.kernel.org
Subject: Re: Strange delays / what usually happens every 10 min?
References: <fhcc39$51b$1@ger.gmane.org> <4739CBF0.8000500@redhat.com>
In-Reply-To: <4739CBF0.8000500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/Vl8fV57PfhmGUTSzj66JcanehRK78mNcKgnB
 4FEydXdZnClMJRjo7AGAIGSxTVJ/DkneQspphrfm7N3OgKoQAB
 v8H0tMIW4g6NOI+Xq8dmw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Chris Snook schrieb:
 > Florian Boelstler wrote:
 >> While running that test driver a delay of about 10ms _exactly_ occurs
 >> every 10 minutes.
 >
 > This is precisely the sort of thing that BIOS/firmware-level SMI
 > handlers do, particularly those that have monitoring or management
 > features.  Try to determine if the kernel is doing anything during this
 > time.  If the entire kernel seems to be frozen, talk to the people who
 > wrote the firmware.

There is no such thing as BIOS on this MPC8540 embedded system.
I guess he is also using some bootloader which just gives full
control to the linux kernel.

Florian:
Check the IP route chache flushes, as Eric mentioned.
I'm working on the MPC854x as well. If you send me your scripts,
I can give them a run here to gather more information.
(I'm about to update my kernels here)

Regards,

Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

