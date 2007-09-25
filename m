Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbXIYIDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbXIYIDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXIYIDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:03:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:5211 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbXIYIDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hbWzC72Ju50H9VxXGl2oDSnA/ENNK6jjH6IYV6By/RnEqsiQXCFMl90EH+Wmr+/9wQnX5UTP4lCSiLdWBN1z8rAoYzGGED/DoBofbPGpsHjpXuGmWnxKInCY/3i4ytH/9/qkBeQy6WJmloYEmVWuM+7mvwKMoh9b0VTzg5MyM98=
Message-ID: <20f65d530709250103s556231a5vbb3741e11197df6c@mail.gmail.com>
Date: Tue, 25 Sep 2007 20:03:27 +1200
From: "Keith Chew" <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: oom on wireless network saturation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We are stress testing the wireless network driver on our linux system.
We use ping flood to saturate the network, and within 24 hours, we
managed to crash the driver.

This was a good test, as it hightlighted a timer problem in the
driver. After fixing that, we are now getting out of memory errors.
The OOM killer starts to kick in and the system freezes.

Can someone advise at a high level, what should the network driver do
in such a scenario? Essentially, the wireless packets get queued up in
the driver and eventually it just breaks. What is the correct way to
handle this gracefully?

Regards
Keith
