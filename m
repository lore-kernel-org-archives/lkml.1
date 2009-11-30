Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZK3KjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZK3KjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZK3KjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:39:08 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:51286 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZK3KjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:39:08 -0500
From: Ian Molton <ian.molton@collabora.co.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, mpm@selenic.com, jeff@garzik.org,
       herbert@gondor.apana.org.au
Subject: hw_random update
Date: Mon, 30 Nov 2009 10:38:19 +0000
Message-Id: <1259577501-17786-1-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259196250-24182-3-git-send-email-ian.molton@collabora.co.uk>
References: <1259196250-24182-3-git-send-email-ian.molton@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final (hopefully) version of my hw_random updates. The first patch updates the
hw_random core to use an appropriately sized and aligned buffer to receive
random data and the second patch adapts virtio-rng to use it, fixing a
previously unprovoked buffer alignment bug as a bonus.

[PATCH 1/2] hw_random: core updates to allow more efficient drivers
[PATCH 2/2] virtio: Convert virtio-rng to the new API
