Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYBQLAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYBQLAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 06:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYBQLAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 06:00:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:56242 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYBQLAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 06:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=vGghtk5PjL2OUpXJk50URaWBTdzEF6n3/5t/FBAdoYH5XlcP9QlXELTUuVHEBfvlj7y5WzK7p2hkMRyVdd6yNXLSFmT56ueYPAxI1spWvR5J9Bq7J94bflcDWlFZydHvbTYCy5tJWAExd1LDWh1qJtdABqRzbSllmx5n/80YCQE=
Message-ID: <c4e36d110802170300t51e45613t4b45c921377bcfd7@mail.gmail.com>
Date: Sun, 17 Feb 2008 12:00:19 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Suspend doesn't work when SD card is inserted
Cc: rjw@sisk.pl
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've noticed that my system (T61) doesn't want to suspend when SD card
is in the card reader slot with 2.6.25-rc2  (no problem when the card
is outside)
Also the card is not even mounted, it's just in the slot and suspend locks.
2.6.24 worked correctly.

Bisection games showed this patch as the source of problem:

775b64d2b6ca37697de925f70799c710aab5849a is first bad commit

Hope this helps

Zdenek
