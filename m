Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569Ab0ANXmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0ANXmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280Ab0ANXme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:42:34 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44016 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0ANXmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=V/wLfrdS7Sij97N6Q24FK+ObVJwWclWZlFlTflkUYPDdlzpK96ZRUv1ElFNTQfDHqY
         9sN+iN9X4HHIQrcPOAcF71RtX3raPQOrwh+EqPXoEUcETfWukXkI79rRTQFEgJiugd+G
         OyUDXjelnz8xpjzcspAzydVSyFBq/edK5OUIg=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Jan 2010 15:42:12 -0800
Message-ID: <43e72e891001141542j4a6c1cdfr715ff092b01bb03e@mail.gmail.com>
Subject: ath3k driver for older kernels
To: linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Vikram Kandukuri <vikram.kandukuri@atheros.com>,
       Alicke Xu <sxu@atheros.com>, Marcel Holtmann <marcel@holtmann.org>,
       Bala Shanmugam <sbalashanmugam@atheros.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ath3k bluetooth driver is now merged on bluetooth-testing and
linux-next trees. The firmware is also now merged onto the
linux-firmware git tree. However if you're on older kernels you won't
have it available. If you're stuck on older kernels you can use this
git tree which just has the ath3k driver alone along with the
firmware:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ath3k.git

Marcel, you OK with us pushing ath3k into for the 2.6.33-rc5? Its a
relatively small and simple driver.

  Luis
