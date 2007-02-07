Return-Path: <linux-kernel-owner+w=401wt.eu-S965690AbXBGQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965690AbXBGQwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965689AbXBGQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:52:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:10051 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965690AbXBGQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MmIyp9EETcZ/nR2z4zc6FXkoTsLWi78Yxjwj2eyD20TA8+syFp77KCP7zmSFYmvqmy0Afck9EQ6bgtE1+hYgzX39MtTndX6JSjYN9HLZ3eHiv3h8twvZzzeaH6DW9V5Fw0lhqvy4l2PL9ujGbF3qwt3DOdVs3wikfmuT2xMGV2A=
Date: Wed, 7 Feb 2007 19:52:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: olecom@flower.upol.cz
Cc: torvalds@osdl.org, zippel@linux-m68k.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: -mcpu strikes back
Message-ID: <20070207165204.GA5537@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The change below is shitting i386 defconfig (as well as my usual config)
build log with warnings:

  CC      init/main.o
`-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
`-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.

gcc is 4.1.1.

------------------
$ git-cat-file commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7
tree 1cdafacd6a0f6e12bd5b88d9031a6130169ca868
parent f6112ec27a8f0eee6c5a996f65c7bfd9457d9f85
author Oleg Verych <olecom@flower.upol.cz> 1170724701 +0100
committer Linus Torvalds <torvalds@woody.linux-foundation.org>
1170801049 -0800

[PATCH] kbuild: improve option checking, Kbuild.include cleanup

 GNU binutils, root users, tmpfiles, external modules ro builds must
 be fixed to do the right thing now.

