Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYLaSzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYLaSzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYLaSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:55:40 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61446 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYLaSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TusrkGLYR67tNtQPbO34FXv3OJGnWYQxx4wIjDJaxQ9ZcofZsFqhrM1Bep2WhKU9J+
         qfKKUWU9kwMQIasW+Cy821DfSn+IeyUtElMQprxCz++0QN1KHMV/h8aUEfgp2yaOuDfN
         Rqoqhwandys8l2xH34IzONOyZgdKVYvHX0Qvo=
Message-ID: <5a4c581d0812311055m5f9f395ci331457f9ed1d1a7f@mail.gmail.com>
Date: Wed, 31 Dec 2008 19:55:35 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-git3 and i915 Kconfig new dependency on framebuffer
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make oldconfig from -git2 to -git3 doesn't build i915.ko unless
 one has CONFIG_FB enabled; this causes /dev/dri/card0 to
 be missing, and DRI disabled from within X.

Do I now (2.6.28-git3+) need CONFIG_FB to enable i915 DRM ?

Thanks,

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
