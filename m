Return-Path: <linux-kernel-owner+w=401wt.eu-S1763081AbZLPWtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbZLPWtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZLPWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:49:45 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:57852 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759414AbZLPWtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:49:43 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [spi-devel-general] [PATCH 1/2] spi: new SPI bus lock/unlockfunctions
Date: Wed, 16 Dec 2009 17:49:41 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200ED81@mi8nycmail19.Mi8.com>
In-Reply-To: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH 1/2] spi: new SPI bus lock/unlockfunctions
Thread-Index: Aco34r4iqplxwar0RoimruADJZQeuBGvwGmQ
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Mike Frysinger" <vapier@gentoo.org>,
       <spi-devel-general@lists.sourceforge.net>,
       "David Brownell" <dbrownell@users.sourceforge.net>
Cc: "Yi Li" <yi.li@analog.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Dec 2009 22:49:41.0443 (UTC) FILETIME=[0DC70930:01CA7EA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 17, 2009 3:03 PM, Mike Frysinger wrote:
>
> From: Yi Li <yi.li@analog.com>
>
> For some MMC cards over SPI bus, it needs to lock the SPI bus for its own
> use.  The SPI transfer must not be interrupted by other SPI devices that
> share the SPI bus with SPI MMC card.
> 
> This patch introduces 2 APIs for SPI bus locking operation.
> 
> Signed-off-by: Yi Li <yi.li@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Has any additional work be done on this patchset?

It would be nice to finally have a solution that lets the mmc_spi driver
work on a shared spi bus.

Regards,
Hartley
