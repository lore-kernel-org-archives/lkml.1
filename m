Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZFAJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZFAJdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZFAJdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:33:04 -0400
Received: from mail201.messagelabs.com ([216.82.254.211]:39562 "EHLO
	mail201.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZFAJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:33:03 -0400
X-VirusChecked: Checked
X-Env-Sender: Luis.Galdos@digi.com
X-Msg-Ref: server-6.tower-201.messagelabs.com!1243848784!27503047!1
X-StarScan-Version: 6.0.0; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Message-ID: <4A23A04A.2030004@digi.com>
Date: Mon, 1 Jun 2009 11:32:58 +0200
From: Luis Galdos <luis.galdos@digi.com>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [LIBERTAS-SDIO]  Support for single transfer blocks?
References: <4A08392F.70108@digi.com>	<20090512231150.bc0c65c6.akpm@linux-foundation.org>	<1242223408.11182.34.camel@localhost.localdomain> <20090513182846.044fc461@mjolnir.ossman.eu>
In-Reply-To: <20090513182846.044fc461@mjolnir.ossman.eu>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
>>> On Mon, 11 May 2009 16:41:51 +0200 Luis Galdos <luis.galdos@digi.com> wrote:
>>>> * The transfer of Ethernet-frames works only if the "complete" frame is smaller than the 
>>>> block size of the SDIO-host. By larger packages, the SD8686 doesn't generate the expected 
>>>> IRQ (cause it expected a multiple transfer) and the driver detects a timeout.
>>>>
> 
> Unfortunately, the libertas chip cannot support your host as it
> requires everything to be done in a single transaction. So I'm afraid
> you'll have to look at another host controller or another wifi chip.
Thanks a lot for this info, this confirms my expectation. And sorry for the delayed 
feedback (I was on vacations).


> Rgds
Regards,


-- 
Luis Galdos
