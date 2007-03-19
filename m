Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbXCSKvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbXCSKvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXCSKvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:51:09 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:44235 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752634AbXCSKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:51:08 -0400
Message-ID: <45FE6A48.10006@aitel.hist.no>
Date: Mon, 19 Mar 2007 11:47:36 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Antonio Vargas <windenntw@gmail.com>
CC: linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       jos poortvliet <jos@mijnkamer.nl>
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive
 cpu scheduler
References: <200703042335.26785.a1426z@gawab.com>	 <200703121714.25034.a1426z@gawab.com>	 <200703130505.05132.kernel@kolivas.org>	 <200703121947.16008.jos@mijnkamer.nl> <69304d110703121158y32e23e85i2896763d04231f0d@mail.gmail.com>
In-Reply-To: <69304d110703121158y32e23e85i2896763d04231f0d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonio Vargas wrote:
>
> IIRC, about 2 or three years ago (or maybe on the 2.6.10 timeframe),
> there was a patch which managed to pass the interactive from one app
> to another when there was a pipe or udp connection between them. This
> meant that a marked-as-interactive xterm would, when blocked waiting
> for an Xserver response, transfer some of its interactiveness to the
> Xserver, and aparently it worked very good for desktop workloads so,
> maybe adapting it for this new scheduler would be good.
And it was dropped because of some very nasty side effect,
probably a DOS opportunity.

Helge Hafting

