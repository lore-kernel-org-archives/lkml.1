Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbXIJXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbXIJXQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXIJXQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:16:32 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:58655 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXIJXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H3BaKeaOHsMUFi5vUGKZf2Ur/SdLVgHoyi6ajXkxE6ezMcmHctEmjutdqYf+HoiIdukSVqtUCBVKaN23OO+TRW8csQFHg4Ll79wxste0V8BsmTk6Ua+UAnGGqcn7P9Rl2mSEYQGExaDiqhOaN7Fu9oejk5795HU9X8LI7k6Q0yM=
Message-ID: <8b67d60709101616s4dbea279y2e54719902c1eee5@mail.gmail.com>
Date: Tue, 11 Sep 2007 00:16:29 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@sourceforge.net
Subject: [PATCH 0/2] Maple bus support for the SEGA Dreamcast
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully these patches are now up to standard.

I have reworked the aica patch also, but I am not including it as I
seem to have the occasional deadlock problem.

I haven't been able to crash these patches without the sound driver
running, so I that seems to be where the issue is - the usual G2 bus
problems.

Following requests the bus driver now has a mutex to guard against a
rogue process adding to the waitq.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
