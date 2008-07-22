Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYGVEUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYGVEUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYGVEUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:20:24 -0400
Received: from usul.saidi.cx ([204.11.33.34]:45558 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750869AbYGVEUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:20:23 -0400
Message-ID: <48855FFB.40808@overt.org>
Date: Mon, 21 Jul 2008 21:20:11 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, randy.dunlap@oracle.com
Subject: Re: [PATCH] toshiba_acpi: Add support for bluetooth toggling	through
 rfkill
References: <488256C1.6040802@overt.org> <20080720135239.GA14801@khazad-dum.debian.net>
In-Reply-To: <20080720135239.GA14801@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> Please consider updating your patch to the new style rfkill class.  A quick
> look at your patch shows that it would benefit from the new
> RFKILL_STATE_HARD_BLOCKED, and maybe to some rework to separate the
> bluetooth rfkill controller and the input device switch better.  Depending
> on the existence of ACPI GPE events when the switch changes state on
> Toshibas, you may even be able to get rid of some of the polling...

Well, if I can find said GPE, I'll certainly use it. A cursory glance through
the dis-assembled AML didn't reveal anything obvious. Is there a way to log
every single acpi event? I though acpid would receive them but it doesn't
appear to.

> If you rework/repost your patch, please CC Ivo (the rfkill maintainer) and
> the linux-wireless mailing list.  If you want me to try to help review the
> patch as well, please also add me to the CC.
> 

I'll do this when I next get enough free time. Thanks for the feedback,

--phil
