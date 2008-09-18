Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYIRNJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYIRNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYIRNJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:09:50 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59322 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbYIRNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:09:49 -0400
Message-ID: <48D25311.1010805@lwfinger.net>
Date: Thu, 18 Sep 2008 08:09:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Michael Buesch <mb@bu3sch.de>, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br> <48D16EDB.8090700@lwfinger.net> <20080918124318.GB1583@khazad-dum.debian.net>
In-Reply-To: <20080918124318.GB1583@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> Curious.  My patch to rfkill WAS tested, and it DOES fix the same issue you
> reported (hardware state changes to HARD_BLOCKED do not update the LEDs) in
> thinkpad-acpi.  It is also an "obviously correct" patch.
> 
> What this probably means is that b43 would need a little more rfkill surgery
> than what Matthew's patch already did.  I will look over Matthew's patch,
> but my guess is that Michael's comments about the need to add some extra
> code to b43 to actually synthesize the rfkill state from the separate HW and
> SW rfkill input lines are a strong hint of where the problem might be.

You must have missed my mail that shows the corrected patch for b43.
See http://marc.info/?l=linux-wireless&m=122171448920267&w=2.

Larry


