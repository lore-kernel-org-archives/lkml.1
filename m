Return-Path: <linux-kernel-owner+w=401wt.eu-S1751595AbZL3AXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbZL3AXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZL3AXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:23:43 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33234 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZL3AXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tK27/58xVQdNAfx5PV8ySrHxe0rpM8A+8px7hbADJ0j2lzQqgqnQryZ2/mzRH39PE6
         MO9Z5N6tkkKLARmwhpONOYTC7PoTvmxhGqV8aeXvFZIq+xeq6yPtcT18uEwYxvGUjyeX
         SV2ovD558aqCjekA/1VX30hNOUycpo9i5kv1s=
Message-ID: <4B3A9D84.5070506@googlemail.com>
Date: Wed, 30 Dec 2009 01:23:32 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH]drivers/input/mouse/hgpk.c:430 unused variable 'dev'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'dev' is unused in function 'hgpk_register'.

Greeting's René Bolldorf

--- ./drivers/input/mouse/hgpk.c  2009-12-30 00:27:24.658980644 +0100
+++ ./drivers/input/mouse/hgpk.c  2009-12-30 00:54:55.374983957 +0100
@@ -427,7 +427,6 @@ static void hgpk_recalib_work(struct wor

  static int hgpk_register(struct psmouse *psmouse)
  {
-    struct input_dev *dev = psmouse->dev;
      int err;

      /* register handlers */
