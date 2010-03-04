Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0CDJNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:13:20 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:63675 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0CDJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:13:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TnyV+7JVIDQw+g2TynoO3YUSjZJqvt08cS/TpW01YfPYF1yTxlSKKil+ZJpOXI+BxD
         2pp2qIuG8IhM5YdlFRA8+2abH+io7bm/HpaLyxS2vhpsPLLmwn+lCIXrrw2cPHKoIEdh
         aoFeHq0snWeWv7iByrL33gpcVB+p3SkKdmPQA=
MIME-Version: 1.0
Date: Thu, 4 Mar 2010 14:43:10 +0530
Message-ID: <9bde694e1003040113k3b573957h1b831c8d25205d22@mail.gmail.com>
Subject: kmemleak issue on ARM target
From: naveen yadav <yad.naveen@gmail.com>
To: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin Marinas ,


W am facing one issue on ARM target, we have 512 MB ram on our target,
we port your patch of
kmemleak(http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg11830.html)

We are facing problem in DEBUG_KMEMLEAK_EARLY_LOG_SIZE we cannot
increase its size above 1000 because of our kernel Image size for
embedded board
has some limit that if it increase we cannot execute it. so is there
any implementaion possible using vmalloc and not statically allocating
the log of array or else any suggestion.

kind regards
Naveen
