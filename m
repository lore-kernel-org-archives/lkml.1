Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZKUNjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZKUNjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZKUNjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:39:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZKUNjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=iq+9SP/vpzC31Nrk1ygo+K7TC+17IySPWjIFV/OqFHYUogaJyX64JAB9IS2XAvcdXd
         YP/HC7DTWX+AdiGdGxF6q5E4kIGvn/+/n4yjmMw33Hwr6Qw6nffiqBEC/e9zWysPEgi5
         XUT3qSr2lLYWrHRFMMj32spKJyyXkxY/+I9sM=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH  0/9] Serial : sc26xx - add SC2892 support
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:39:51 +0100
Message-ID: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the SC2892 DUART.

This chip is quite similar to the SC2692 but has more baud rates
and bigger FIFOs.

The driver should probably be renamed (sc2xxx ??) but I haven't
done that yet to keep the patches readable.

I also intend to add support for the 28202 chip.

Unfortunately not having SC2692 hardware I haven't been able
to regression test this.


