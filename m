Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXJBJI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXJBJI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXJBJIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:08:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXJBJIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:08:48 -0400
Message-ID: <47020A9E.6090602@anagramm.de>
Date: Tue, 02 Oct 2007 11:08:46 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alexander Sabourenkov <screwdriver@lxnt.info>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Promise SATA300 TX4: errors, oops in ext3 code
References: <47009BF6.5000208@lxnt.info> <4700B966.1030508@anagramm.de> <4701CAA9.6070902@lxnt.info>
In-Reply-To: <4701CAA9.6070902@lxnt.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+k58X9GGwdRRaM65+GV5f1qHTInxjVFnEIDKw
 d8gXRhKPOj1OdIKSgVakffeAOooHnRORL+vEpXOJSJu7OFeInO
 /ZsW6K0tXwrNhsW3D5vcw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Sabourenkov schrieb:
 >> Have you checked your memory already (memtest86)?
 > [...]
 >> Again... sounds like bad memory to me.
 > Nightly memtest86  run : 11 hours, 23 passes, 0 errors.

Okay, I have no idea about any bugs there.
You have several options: Find a 100% working vanilla kernel for your
problem (minimal configuration, skip i.e. the sound stuff, ...).
And then git bisect with a known bad kernel.

Same thing in hardware: move components (Controllers + HDD) to/from a working
machine and verify...

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
