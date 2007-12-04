Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbXLDL50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbXLDL50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXLDL5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:57:19 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:38795 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXLDL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:57:18 -0500
Subject: Re: Stack warning from 2.6.24-rc
From: Jon Masters <jonathan@jonmasters.org>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <955170.47530.qm@web32601.mail.mud.yahoo.com>
References: <955170.47530.qm@web32601.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 04 Dec 2007 06:56:41 -0500
Message-Id: <1196769402.27258.158.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-04 at 03:46 -0800, Martin Knoblauch wrote:
> Hi,
> 
>  I see the following stack warning(s) on a IBM x3650 (2xDual-Core, 8 GB, AACRAID with 6x146GB RAID5) running 2.6.24-rc3/rc4:
> 
> [  180.739846] mount.nfs used greatest stack depth: 3192 bytes left
> [  666.121007] bash used greatest stack depth: 3160 bytes left
> 
>  Nothing bad has happened so far. The message does not show on a similarly configured HP/DL-380g4 (CCISS instead of AACRAID) running rc3. Anything to worry? Anything I can do to help debugging?

This is enabled by CONFIG_DEBUG_STACK_USAGE, which defines
check_stack_usage. It is called on task exit and will warn each time a
task has used the biggest kernel mode stack since booting. This isn't a
bug, and isn't a (bad) warning, it's just informational right now.

Jon.


