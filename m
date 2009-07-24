Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbZGXNgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbZGXNgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZGXNgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:36:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47481 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZGXNgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VvDgxE9EdMLCUSGw76wR8SW05FBEHQOtKalfHeLdaVKLNA1bl83Us24JzEAMKjbUCY
         K4IQ2sxMGcodhTSFo6rcDLOFc/9MrCX7o+Jo9aRp1ORQfvshEu5wPYuLDOLP54nfG1De
         1+yicmN98bra2EU2d8JvjACHUk6IOyLNv9sK8=
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 09:36:53 -0400
Message-ID: <194f62550907240636o5ba623cdy1f16deb7f6d70eeb@mail.gmail.com>
Subject: Status of ext4 online defrag?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Does anybody know what the current state of ext4 online defrag is?

Although ext4 does an excellent job in avoiding fragmentation,
sometimes it still happens, e.g. with firefox's sqlite database
which made using firefox horrible because disk-io took ages (and took
also some time until I found out whats the problem):

> [ce@localhost ~]$ filefrag /fc8/home/ce/.mozilla/firefox/default/places.sqlite
> /fc8/home/ce/.mozilla/firefox/default/places.sqlite: 1730 extents found, perfection would be 1 extent

Thats 1730 extents for a 75mb file :-/
Sure I can copy it between my partitions, but I would really prefer a
defrag tool ;)

Thank you in advance, Clemens
