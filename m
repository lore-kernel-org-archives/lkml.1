Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZAJBjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZAJBjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbZAJBjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:39:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:59043 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZAJBjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:39:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ryN7b2PY0ZN+y5kkdAVejsJdhD1GDbSbiSX0gb3uo+xWDg2j3dJZBaPhaKixS80zjU
         1/778MXb3ukwKXIaNyNzdSOwgUYo+UpmNoSPkMJdY9dscKU9vrCYwWEejpHKGLLnp9nC
         KqECdFxw0ZHSeIK40QGMhkWwZASLiL3dhHadM=
Message-ID: <b6a2187b0901091739i58beb14ft2990d563096f8c67@mail.gmail.com>
Date: Sat, 10 Jan 2009 09:39:05 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.28-git can't resume from str
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest kernel failed to resume from suspend-to-ram. It was just
recently fixed in commit a0e280e0f33f6c859a235fb69a875ed8f3420388

commit a0e280e0f33f6c859a235fb69a875ed8f3420388
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Wed Jan 7 16:19:46 2009 +0100

    stop_machine/cpu hotplug: fix disable_nonboot_cpus


Git bisect points to this bad commit ...

commit e3f47f89a57ef115755184a8b3f03a47ee227418
Author: Daniel Drake <dsd@gentoo.org>
Date:   Wed Dec 10 23:28:25 2008 +0200

    USB: unusual_devs.h additions for Pentax K10D


But I can't seem to revert this commit cleanly.

Anyone else having issue with resuming from STD?

Thanks,
Jeff.
