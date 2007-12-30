Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbXL3Wmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbXL3Wmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXL3Wmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:42:36 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:32832 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbXL3Wmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:42:35 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Sun, 30 Dec 2007 23:42:30 +0100
Subject: RAID timeout parameter accessibility request
From: Jose de la Mancha <hidalgoj@free.fr>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C39DDD66.F5A0%hidalgoj@free.fr>
Thread-Topic: RAID timeout parameter accessibility request
Thread-Index: AchLNUJvgMd9CLcoEdyZCAADk7o1Ig==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone. I'm sorry but I'm not currently subscribed to this list (I've
been sent here by the listmaster), so please CC me all your
answers/comments. Thanks in advance.

SHORT QUESTION :
In a Debian-controlled RAID array, is there a parameter that handles the
timeout before a non-responding drive is dropped from the array ? Can this
timeout become user-adjustable in a future build ?

EXPLANATIONS :
As you might know, if you install and use a "desktop edition" hard drive in
a RAID array, the drive may not work correctly. This is caused by the normal
error recovery procedure that a desktop edition hard drive uses : when an
error is found on a desktop edition hard drive, the drive will enter into a
deep recovery cycle to attempt to repair the error, recover the data from
the problematic area, and then reallocate a dedicated area to replace the
problematic area. This process can take up to 120 seconds depending on the
severity of the issue.

The problem is that most RAID controllers allow a very short amount of time
(7-15 seconds) for a hard drive to recover from an error. If a hard drive
takes too long to complete this process, the drive will be dropped from the
RAID array !

Of course there are "RAID edition" hard drives with a feature called TLER
(Time Limited Error Recovery) which stops the hard drive from entering into
a deep recovery cycle. The hard drive will only spend 7 seconds to attempt
to recover. This means that the hard drive will not be dropped from a RAID
array. But these "special" hard drives are way too expensive IMHO just for a
small firmware-based feature.

There would be an easy way to allow users to use "ordinary" hard drives in a
Debian software-controlled RAID array. So here's my request : I suppose
there is a parameter that handles the default timeout before a drive is
dropped from the RAID array. I don't know if this parameter is hardcoded,
but it would be nice if it was user-adjustable. This way, we could simply
set up this parameter to 120 seconds or more (instead of 7-15) and we
wouldn't have any more problems with using desktop "edition hard" drives in
a RAID array.

What do you think ? Can it be done in a future build ?

I really hope that you'll be able to help, because I guess a lot of people
can be concerned by this issue.

Many thanks in advance & Best regards.

Jose


