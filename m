Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbXB1GLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbXB1GLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 01:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXB1GLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 01:11:35 -0500
Received: from sslsrv.de ([62.75.159.123]:39327 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbXB1GLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 01:11:34 -0500
Message-ID: <26291.193.171.152.33.1172643093.squirrel@webmail.marek.priv.at>
In-Reply-To: <054301c75a66$e78bc790$4b00a8c0@donald>
References: <37295.193.171.152.61.1172576225.squirrel@webmail.marek.priv.at>
    <054301c75a66$e78bc790$4b00a8c0@donald>
Date: Wed, 28 Feb 2007 07:11:33 +0100 (CET)
Subject: RE: Using dm-crypt for encrypting files
From: "Ph. Marek" <philipp@marek.priv.at>
To: rol@as2917.net
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
>> - encrypts new files depending on their filename, and generally
>
> What about renaming a file ???
Well, that's a small (but known!) problem with this scheme.
If you say that everything below a directory "_crypt_" should be
encrypted, and just move files in there, you've got no problems - the
encryption settings stay the same.

If you move in/out of encrypted storage, there's two options:
- if it's a separate filesystem, ie. mounted, you cannot move - you
  have to copy & delete, which means the data gets correct settings.
- if its not the same filesystem, you might get a wrongly en/decrypted
  file.

But I just saw ecryptfs (http://ecryptfs.sourceforge.net/) - that seems to
do more or less what I need. I'll take a look.


Regards,

Phil



-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
