Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbZASM5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbZASM5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759212AbZASM5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:57:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49767 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbZASM5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:57:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=RLyV9bpFiVZ9rb6JcQny9cmGlLn/HzG99uXT/XY7/E8wC1eOPB6n297sFYGJ7NxsXY
         F/bhFkUxVyjrnO9WJmtmiMX+Imstka6O7aIyLBLxJfqqp/mdUwa5FrgAUaw3v9ju9yop
         cXpOwulXp+Hac5kcUR5l3ItmVz42XN4S67Bj4=
Date: Mon, 19 Jan 2009 15:56:21 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bikeee
To: linux-kernel@vger.kernel.org
cc: hannes@saeurebad.de
Subject: emacs indenting howto
Message-ID: <alpine.DEB.2.00.0901191521270.2904@bikeee>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think emacs understands tilda expansion.  It didn't work for me.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/Documentation/CodingStyle	2009-01-16 17:46:16.000000000 +0300
+++ devel/Documentation/CodingStyle	2009-01-16 17:48:13.000000000 +0300
@@ -488,7 +488,7 @@
              (let ((filename (buffer-file-name)))
                ;; Enable kernel mode for the appropriate files
                (when (and filename
-                         (string-match "~/src/linux-trees" filename))
+                         (string-match "/path/to/linux-trees" filename))
                  (setq indent-tabs-mode t)
                  (c-set-style "linux")
                  (c-set-offset 'arglist-cont-nonempty
