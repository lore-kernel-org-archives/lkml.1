Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYIUTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYIUTky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYIUTkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:40:46 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43528 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYIUTkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:40:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18646.41781.532427.35962@harpo.it.uu.se>
Date: Sun, 21 Sep 2008 21:40:37 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] log fatal signals like SIGSEGV
In-Reply-To: <E1KhUOj-0003x9-00@calista.eckenfels.net>
References: <18646.39701.819497.337394@harpo.it.uu.se>
	<E1KhUOj-0003x9-00@calista.eckenfels.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels writes:
 > In article <18646.39701.819497.337394@harpo.it.uu.se> you wrote:
 > >   Applications that handle SEGV/BUS/ILL/FPE aren't that uncommon.
 > 
 > JRE uses SIGSEGV for (expected) NullPointers. So you might see a lot of
 > those on the logs. However: not in all cases you dont want to log handled
 > (fatal) signals. Not sure how to detect those. Maybe it is better to fix
 > applications and remove their home grown crash logging.

I was referring to applications that properly handle these signals,
e.g. by emulation, fixing up fault-causing conditions, or turning
faults into application-level exceptions.
