Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYAWJOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYAWJOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYAWJOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:14:42 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:18293 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYAWJOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=svm/JOJLtiSEKgZyLR7Eu+UgbA5EXWigVOmDrQut6l2+y5MyjDt5seAjc4FP3b9ofI16tWCUeg8F/OQK6rjh5vUhWkibJtm90SUIho0hniNXJIBG818KmERxUogS7yobMUJ+v8hMCsFcbFd10IZiimEuYn2K56gs3/Iv/ydPnAM=
Message-ID: <9b06e8d20801230114v1e09e5e8s6a4b438562c62619@mail.gmail.com>
Date: Wed, 23 Jan 2008 10:14:39 +0100
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: vmalloc_32 and SLAB incompatible in 2.6.23.9
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

     Since GFP_DMA32 is not considered a valid flag, vmalloc_32 and
  SLAB are incompatible in kernel 2.6.23.9 (and probably later ones).
  It might be as simple as adding GFP_DMA32 everywhere where
  GFP_DMA is used in mm/slab.c, but I don't dare do it. I personally
  switched to SLUB.

      Thanks,

          Loïc Grenié
