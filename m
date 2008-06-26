Return-Path: <linux-kernel-owner+w=401wt.eu-S1764860AbYFZNkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764860AbYFZNkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYFZNjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:39:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42594 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753809AbYFZNjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:39:47 -0400
Date: Thu, 26 Jun 2008 14:18:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 46/60] microblaze_v4: termbits.h termios.h
Message-ID: <20080626141837.0f8f439d@lxorguk.ukuu.org.uk>
In-Reply-To: <1214483429-32360-47-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	<1214483429-32360-32-git-send-email-monstr@seznam.cz>
	<1214483429-32360-33-git-send-email-monstr@seznam.cz>
	<1214483429-32360-34-git-send-email-monstr@seznam.cz>
	<1214483429-32360-35-git-send-email-monstr@seznam.cz>
	<1214483429-32360-36-git-send-email-monstr@seznam.cz>
	<1214483429-32360-37-git-send-email-monstr@seznam.cz>
	<1214483429-32360-38-git-send-email-monstr@seznam.cz>
	<1214483429-32360-39-git-send-email-monstr@seznam.cz>
	<1214483429-32360-40-git-send-email-monstr@seznam.cz>
	<1214483429-32360-41-git-send-email-monstr@seznam.cz>
	<1214483429-32360-42-git-send-email-monstr@seznam.cz>
	<1214483429-32360-43-git-send-email-monstr@seznam.cz>
	<1214483429-32360-44-git-send-email-monstr@seznam.cz>
	<1214483429-32360-45-git-send-email-monstr@seznam.cz>
	<1214483429-32360-46-git-send-email-monstr@seznam.cz>
	<1214483429-32360-47-git-send-email-monstr@seznam.cz>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/include/asm-generic/termbits.h
> @@ -0,0 +1,200 @@

> +/* c_cflag bit meaning */
> +
> +#define CBAUD	0010017
> +#define B0	0000000 /* hang up */

You need BOTHER in here as well - especially if it is going to be generic.

