Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZETJQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZETJQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZETJQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:16:13 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:39927 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZETJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=onlPF80IU5rsypfupTH7zZ1RfCN5baiLaZhdUFWpMQ6AHtwjzLiKKaySdhl6HRRUUW
         Q90fkXj05za0i81I6rWPc7yWGDSfUUz/OC2xqJj8Rko9tCDclZiquXaLjp8Nc/43OZeB
         kJqXregdSVNg12dTYhIo6E3tAjjHeHF/x8fwg=
MIME-Version: 1.0
Date: Wed, 20 May 2009 11:16:13 +0200
Message-ID: <63386a3d0905200216q209849e4wd4f2b73d06c74be0@mail.gmail.com>
Subject: [PATCH 0/1] MFD: Add U300 AB3100 core support v4
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog from v3 -> v4:

* Set parent to the AB3100 subdevices properly.

* Some brace placement fix-up.

* Error print on main struct allocation failure.

* Remove register range definitions for subdevices
  for the time being. It's unclear if IORESOURCE_IO
  is applicable for this usecase. No other MFD devices
  do this anyway.

* Remove machine-specific debug flag requirement for
  this driver to expose debugfs. This can be used on
  other machines so CONFIG_DEBUG_FS.

Yours,
Linus Walleij
