Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXFJSbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXFJSbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXFJSbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:31:39 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:59735 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXFJSbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:31:38 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cat /dev/snapshot == OOPs
Date: Sun, 10 Jun 2007 20:31:29 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
References: <200706101542.33951.arekm@maven.pl> <200706101933.53647.rjw@sisk.pl>
In-Reply-To: <200706101933.53647.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706102031.29459.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 of June 2007, Rafael J. Wysocki wrote:

> >
> > [54498.464550] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)
> > initialised: dm-devel@redhat.com
> > [56592.077674] swsusp: Basic memory bitmaps created
> > [56592.084340] BUG: unable to handle kernel NULL pointer dereference at
> > virtual address 0000000c
>
> Can you please try the appended patch?

[root@tarm ~]# LC_ALL=C cat /dev/snapshot
cat: /dev/snapshot: No data available

[  237.939976] swsusp: Basic memory bitmaps created
[  237.956642] swsusp: Basic memory bitmaps freed

no oops with that patch.

> Rafael


-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
