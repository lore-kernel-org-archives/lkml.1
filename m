Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZCSPfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZCSPfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZCSPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:34:49 -0400
Received: from mail.agmk.net ([91.192.224.71]:33420 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbZCSPet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:34:49 -0400
To: "Aristeu Rozanski" <aris@ruivo.org>
Subject: Re: [2.6.9] NMI watchdog detected lockup.
Date: Thu, 19 Mar 2009 17:34:43 +0200
X-Mailer: IlohaMail/0.8.13 (On: agmk.net)
Message-ID: <XMIRY4y3.1237476883.0521700.pluto@agmk.net>
In-Reply-To: <20090319133753.GB5507@cathedrallabs.org>
From: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
Bounce-To: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19/3/2009, "Aristeu Rozanski" <aris@ruivo.org> napisa³/a:

>> NMI Watchdog detected LOCKUP, CPU=0, registers:
>something (probably the Jungo driver) is using too much time and the NMI
>watchdog is not being reset often enough. try booting with nmi_watchdog=0
>kernel parameter and check if the driver works. if the machine hangs, it means
>that the NMI watchdog was right and the CPU was really stuck because of a bug.
>contact your vendors and inform the results.

with nmi_watchdog=0 machine hard freezes.
anyway, thanks for help.
