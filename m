Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYGVEnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYGVEnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYGVEnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:43:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:49885 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYGVEnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Y3WI4iUZXlr3Zo25bkfaPjgWYMewf+UeqltFlDDFsRnguNTx1ThzUCCatWB7/Y0Bhw
         2kXAP/WacGH00fIo1FCMDjGix3LlrZl58CFs6tSFUEqXGotUKODLrJpdAyFVYpEHQwBs
         g0mDqDoBPDO7b5w0ZbGfYzshB5tkcDUbPVtRw=
Message-ID: <d82e647a0807212143r2f598a59y76a79fd9bb8f17@mail.gmail.com>
Date: Tue, 22 Jul 2008 12:43:03 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: netdev@vger.kernel.org
Subject: BUG: iwlwifi build failed
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 93ded9b8fd42abe2c3607097963d8de6ad9117eb
Merge: 6d52dcb... f756cbd...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jul 21 15:42:20 2008 -0700
=====================================

drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str'
undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared
identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function
it appears in.)
make[4]: *** [drivers/net/wireless/iwlwifi/iwl-led.o] Error 1
make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


-- 
Lei Ming
