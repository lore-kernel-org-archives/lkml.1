Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbZKDXlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbZKDXlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZKDXlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:41:15 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:45090 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZKDXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:41:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=e3KWwMAldlKkDQVdMy4ZzafxWfwNaUYDTLezRyWKPUoD9owmfBewYs1JiR3L1OQknN
         AI/QxDfSeyuMcuhUI/qTFFqVJ5NlNAJrRNCKZk1rdve9SjLkCq+cvKfV+pc5shd0i7n4
         niYoy9w6x3WJsPEbOsReDbn8Tfie6vwYbAo6g=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 15:40:59 -0800
Message-ID: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com>
Subject: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

reverting the commit 5d423, titled "x86/pci: remove rounding quirk
from e820_setup_gap()" fixes loading of ath9k on an Acer Extensa
7630EZ. We've troubleshooted the issue with the user,  Bernhard, who
eventually did a full bisect between 2.6.30 and 2.6.31 and found 5d423
was the culprit. For details please feel free to check:

http://bugzilla.kernel.org/show_bug.cgi?id=14402

Can you please consider reviewing this issue and help determine if
this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.

I am curious if other devices would work by reverting this as well.

  Luis
