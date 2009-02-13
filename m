Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbZBMQbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbZBMQbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbZBMQ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:29:41 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:49424 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761776AbZBMQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:29:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=hsKoWyGOc7uB8/AKEXw5/IqesJxRwNltI9iu0oFySwDRcK94H/m6k4a6+WCwMlsRCD
         IPKI4SkBCs7vNT8aj+8gGaD00pI8jzpNAIqHFTwF1JUd/eBX1if/oqmn4h3N8eCQVUar
         szy1IZt2sdJmhJz6E5Qf+YHOhW1bTct7jDEhI=
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 17:29:36 +0100
Message-ID: <6bd94bae0902130829r15e6eacag25220487457027ad@mail.gmail.com>
Subject: contact problem? (was Re: Spurious Filesystem corruption with ext3 + 
	large (<400GB) hw RAID ...)
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 7:50 PM, Ray Lee <ray-lk@madrabbit.org> wrote:

> Huh. It may be related to whatever kernel version Ubuntu uses to boot
> up the install media. Try a different version of Ubuntu (older, newer
> if a newer one exists) to see if it has the same problem.

Thank you for your notice but as I mentioned the problem occurred
first with my custom built kernel and the Ubuntu installation disk was
used only to reproduce the error -- Ubuntu is not what I use anyhow,
I'm on Debian since I switched from Slackware in 1995 ;-)

But now it looks like we had an exotic hardware problem here. Just
before the weekend the RAID controller reported a degraded array and
switched to the hotspare disk. On Monday the original array was
recreated and everything worked fine until Tuesday morning when the
array again was degraded. But then since the disk was checked and
reinserted into the array all problems are gone :-\

Is it possible that such a problem is caused by bad contact within the
drive bay connector?

The reason why it occurred with ext3 only might then be that ext3
stores it's backup superblocks at addresses which are otherwise unused
by a largely empty filesystem.

regards Manfred
-- 
Unix "Birthday" on 2009-02-13 23:31:30 UTC
...it's 1234567890 seconds since the epoch.
