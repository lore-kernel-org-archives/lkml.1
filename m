Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZEUVQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZEUVQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 17:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZEUVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 17:15:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:49487 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZEUVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 17:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IuuIajn6OEoXap4G0ALh2JQIQSFBX1m72dYAOQWHMK03DK4g9uewLwuEdN6Iii/R3l
         jDYITnQiW71AvZgfz5rAu8IXFSasTNj623eWyZkzRlOGlVXfZgyNk1Ug5a+Lkp1qINNU
         liZnxnPkLhXN+pu2YMstIXTBu5Mo8v//8/c88=
MIME-Version: 1.0
Date: Thu, 21 May 2009 23:15:53 +0200
Message-ID: <63386a3d0905211415r3c83c24ftbf2b140139573f56@mail.gmail.com>
Subject: [PATCH 0/1] MFD: Add U300 AB3100 core support v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog from v4 -> v5:

* Remove the singleton pattern. Now we can instantiate
  several AB3100 chips on the same system if we want to,
  this won't happen in practice but it makes the driver
  look more similar to other drivers so it's nice.

* Consequently pass around the struct ab3100 * token
  instead of using the local singleton inside the
  driver.

* Replace all "ab3100_data" suffixes on variable
  names with a plain "ab3100" since there is not
  difference between these anymore.

* Pass a small struct to the get/set register debugfs
  functions in order to pass mode of operation as well as
  a pointer to a struct ab3100 * in the file private data.

* Correct file permissions on write-only debugfs files.

* Hoping that Sam will accept this into the -mfd tree...


Yours,
Linus Walleij
