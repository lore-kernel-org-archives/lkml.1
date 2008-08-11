Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYHKRD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYHKRD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbYHKRDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:03:19 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:18184 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbYHKRDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:03:17 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Opteron Rev E has a bug ... a locked instruction doesn't act as a read-acquire barrier (confirmed)
Date: Mon, 11 Aug 2008 19:03:06 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: "Wahlig, Elsie" <elsie.wahlig@amd.com>, linux-kernel@vger.kernel.org
References: <CB2417C2B1152C41919D5B9DE58840FA72D828@sausexmb5.amd.com> <200808061913.34874.arekm@maven.pl> <18585.64037.521673.362547@alkaid.it.uu.se>
In-Reply-To: <18585.64037.521673.362547@alkaid.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808111903.06953.arekm@maven.pl>
X-Agnat-Warning: Use smtp.agnat.eu as SMTP server
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Mikael Pettersson wrote:
> On Wed, 6 Aug 2008 19:13:34 +0200, Arkadiusz Miskiewicz wrote:
> >On Wednesday 06 August 2008, Wahlig, Elsie wrote:
> >> Your issue may be one that has been seen on 1st generation
> >> AMD Opteron processor's with cpuid family 0Fh, cpuid model's
> >> < 40h with the code sequence that performs a read-modify write
> >> operation after acquiring a semaphore.
[...]
> Also I think I'll start by writing a user-space test program that
> does a stress-test of the plain lock;rmw;unlobk sequence to see if
> it can break it. (Locks/mutexes are also used in user-space.)

Bugreported so hopefully it won't be lost.

http://bugzilla.kernel.org/show_bug.cgi?id=11305

> /Mikael

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
