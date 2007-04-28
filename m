Return-Path: <linux-kernel-owner+w=401wt.eu-S1161866AbXD1RHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161866AbXD1RHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXD1RHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:07:33 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:32869 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbXD1RHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YOPk5tzTKxrN22qTNanftkgvfWDSO90O0S32avOkh2963KWsgIerlK5Yg6FKB6ouo6ga9FlKjS6dBlKRxnRH8GWT9T/2XKgNlAtwTIQ6ltxAAtFqLHVW51YHGT1VQp+YPTBEwweXouhFPq9r8mDztUTGSLWdU1jTY3c5JO+GK4g=
Message-ID: <46337F56.3010904@gmail.com>
Date: Sat, 28 Apr 2007 20:07:34 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <257974.51495.qm@web36707.mail.mud.yahoo.com>
In-Reply-To: <257974.51495.qm@web36707.mail.mud.yahoo.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> I prepared a tarball with 2.6.21 compatible driver (tifm-0.8e on berlios).
This is "good enough" to withdraw my patch. I have filed it to
http://bugzilla.kernel.org/attachment.cgi?id=11312&action=view

in bug 8052
http://bugzilla.kernel.org/show_bug.cgi?id=8052

which seems to be resolved by the patch.

 > I don't see any problems on stock 2.6.21.1.


Well, this version seem to ignore cards which are present at
load.

I have this output:
~$ check once
Loading module tifm_sd ...
Checking for a card at /dev/mmcblk0p1 ...
failed.

for this script:
http://bugzilla.kernel.org/attachment.cgi?id=11317&action=view

and you can can see this bug for more details:
http://bugzilla.kernel.org/show_bug.cgi?id=8393

