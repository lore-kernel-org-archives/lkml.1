Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbZFXDuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbZFXDuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZFXDuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:50:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20393 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZFXDuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gido4DPygw8GEDZtXinu8+BnjRSmvOWicxh9pgnNetcNJApZcdF43LjKGK3yLuxY1g
         JgfbUc4UODaZyyWTZFDI9VE9vpY67R3Ds8PVazuxQoowuIBnQkatca/ZQWjQNgVx6XIQ
         B7RUEBb8eJ8GS0aqlzGryYxo2LEQ1x8cgF1nU=
MIME-Version: 1.0
Date: Wed, 24 Jun 2009 11:50:06 +0800
Message-ID: <cb9ecdfa0906232050n6fcfee31ubeee4bcd9b8c0dfe@mail.gmail.com>
Subject: How the kernel printk works before do console_setup.
From: Johnny Hung <johnny.hacking@gmail.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:
    I have a powerpc arch platform. The default console is ttyS1 not
ttyS0 in the platform. My question is how the kernel print debug
message
like DBG before parse kernel command line and do console_setup
function. The command line passed to kernel about console info is
console=ttyS1.
So kernel can not print anything before parse cmd line and initial
console but the result is against. Anyone point me or give me a clue
is appreciate.

BR, H. Johnny
