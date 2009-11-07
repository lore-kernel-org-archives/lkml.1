Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZKGBpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZKGBpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 20:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZKGBpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 20:45:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:32890 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZKGBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 20:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HdjHIv4nU6kOrqbnPUzhiLN5ykfxBJ+XCjpdwanvWDCFlCO1DnidVKxFSUOGOllgMI
         gFtg+kqrk0UHuDJOKRNwrqaYoFocriMDCR+92vziOrpeEbsGx9XrZDNgwPDEsTllx308
         UVzgIx2PxuolEuu69vfjDXOOQC1fpLGzw3paE=
MIME-Version: 1.0
In-Reply-To: <a4c8a6d00911061723v6017ad7bqf96ba7c905922a45@mail.gmail.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
	 <20091106224728.GA32205@kroah.com>
	 <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
	 <20091107000749.GA26070@kroah.com>
	 <a4c8a6d00911061723v6017ad7bqf96ba7c905922a45@mail.gmail.com>
Date: Fri, 6 Nov 2009 23:45:05 -0200
Message-ID: <a4c8a6d00911061745s4508d997v684683a1dbad821d@mail.gmail.com>
Subject: Re: [PATCH v2] staging/otus: trivial, fix sparse warnig.
From: Thiago Farina <tfransosi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*apdbg.c: use NULL pointer instead of 0 integer.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/staging/otus/apdbg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index d3e2f62..70a40b8 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -109,7 +109,7 @@ int set_ioctl(int sock, struct ifreq *req)

 int read_reg(int sock, struct ifreq *req)
 {
-    struct zdap_ioctl *zdreq = 0;
+    struct zdap_ioctl *zdreq = NULL;

     if (!set_ioctl(sock, req))
         return -1;
@@ -123,7 +123,7 @@ int read_reg(int sock, struct ifreq *req)

 int read_mem(int sock, struct ifreq *req)
 {
-    struct zdap_ioctl *zdreq = 0;
+    struct zdap_ioctl *zdreq = NULL;
     int i;

     if (!set_ioctl(sock, req))
