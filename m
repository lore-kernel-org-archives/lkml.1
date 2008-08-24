Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYHXJ2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYHXJ2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYHXJ2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:28:35 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:12880 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYHXJ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sQJm7z+hOG/07Ts2FsUdp1pc5Nc1WMhtE6k+3N+qGUwOHhm60ZQkB9CfrPmwOEG9zR
         Vlgw6NRMlal0hDMoMHZDaaMS76CQC3GqcfB4hMCrctbsmUv0ZTeOGhsJRbxwJrakWBWC
         G6TcKSb4Yxnz2IOF3DVZzObr6h4igHgKlBuw4=
Message-ID: <2084b47d0808240228k3bcf2d77v5409197eab7719e1@mail.gmail.com>
Date: Sun, 24 Aug 2008 11:28:34 +0200
From: Jose <jmalv04@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: mmap - mlock problems
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found this old thread /lkml/2001/10/30/256 which uncovered
some mmap problems with 2.4.x kernels.

I ran the test program on a 2.6.21 x86_64 with 2GB and the test program
doesn't make the system unusable but it fails when it runs out of
free memory and has to start recycling.

This is almost the same to the original problem and I wonder whether
there is a missing patch somewhere or any reason why
this was not fixed in newer versions.

thanks
