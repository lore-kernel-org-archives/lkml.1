Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZIHCBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZIHCBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZIHCBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:01:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60607 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZIHCBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=GyEJPJ1TsG9kOJh/Wl8jbR44nPeuG7Xp4b+XijLnQ3WOO2W22pc5atgrit1SB1Bot0
         xBty4hNiuSE192dxFEp40QE83RJHMXU5oeZKI++nTGkQvZRZXtYYNXSKbUpubmGUOwEg
         8Gr9mYVxV0kMG5OpErFRBN6eQphLcYwP63OyU=
MIME-Version: 1.0
From: =?UTF-8?Q?Piotr_Jaroszy=C5=84ski?= <p.jaroszynski@gmail.com>
Date: Tue, 8 Sep 2009 04:00:38 +0200
Message-ID: <d77765540909071900q41ebcac5n4b0f06e8ebe2efcc@mail.gmail.com>
Subject: user time going down on successive reads
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

i'm working on software that is archiving utime (and stime and some
other stuff too) of processes running in the system for later
analysis. I am reading all that data from /proc/[pid]/stat and I have
noticed that utime can actually go down on successive read (10 secs
later in this case). How is it possible? Is this a bug or I just don't
fully understand what utime is?

I have kernel 2.6.30.5 if that matters.

Thanks in advance for help.

-- 
Best Regards,
Piotr Jaroszyński
