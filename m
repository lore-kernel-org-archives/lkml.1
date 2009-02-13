Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbZBMHnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbZBMHnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBMHnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:43:12 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:44762 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZBMHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=B+i1Isf8Ak0+GuT9nSbFiuoprpjLqbOvG/za9W/Qr39s6JxSkTU66Dbx6BWboUe1w4
         +eu+AIfs8ZFOuWAls6T+NKTgrhgYXrPBtLP738udiVj8HWCOC8pywqI5fmeaM6dtsWFB
         G4GrXS1GQlbI6uiqVlOTp1XxNm+t36h1pRwv0=
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 08:43:10 +0100
Message-ID: <9a955d090902122343l17820a0dx7863d24d421dc9d@mail.gmail.com>
Subject: PROBLEM: [mach-orion5x, dns-323] MTD kernel partition too small
From: mrpace2 <mrpace2@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the 2.6.29-rc4 kernel with orion5x_defconfig and
gcc-4.3-arm-linux-gnueabi yields a zImage of 1753672 bytes. This
zImage plus uboot header doesn't fit into the MTD kernel partition in
flash which arch/arm/mach-orion5x/dns323-setup.c defines as
.size=0x00180000. The kernel partition should have least 0x001b0000
bytes.

-Frank
