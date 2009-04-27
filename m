Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZD0IVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZD0IVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZD0IVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:21:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:23390 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZD0IVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ElnZhOCIvGbIlJXc3f0aa56A1scjDH3/RVbZHS3m4/WTr2hEcu+sDHK2Gju+VU4APt
         RZjHV7WLtmaK1qU+7DDC10k8W2syL9DU4764/2DN4wYelaH8/4zwblYmDnvdrNnLAkvp
         2FWqyK4/CqbImE8wgF3nnbWRajir5a7yBVJlE=
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 18:21:03 +1000
Message-ID: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
Subject: kms in defconfig
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.

This should never be the case, as anyone who built defconfig kernels before,
will now get KMS enabled when really they need to have done userspace upgrades.

KMS should default to n in the upstream kernel, for at least 4-5 years.

Dave.
