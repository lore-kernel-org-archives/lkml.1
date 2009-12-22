Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZLVAVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZLVAVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZLVAVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:21:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38332 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZLVAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:21:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ByqPvx1MYcfvO/4Tv8TkNQDBMTpis+EA/ZWTz8+pLLvLCzeWzkBAiVmyfsUNiWatTr
         RkkUncR6TeVoiVL/+7pOx4MuiD0Pj1U8K7e1I1N/3G2a30FYPB79w9X6Nk53U2zA86N7
         L6Qs5arxXAQggp8Xvlueh/BK+FUXInETPJZjA=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 01:21:28 +0100
Message-ID: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>
Subject: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tabbott@ksplice.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CONFIG_STATIC_LINK=y is broken since 2.6.32.
The linux binary segfaults immediately.

This patch introduced the regression (bisected):
5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 is first bad commit
commit 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80
Author: Tim Abbott <tabbott@ksplice.com>
Date:   Thu Sep 24 10:36:20 2009 -0400

    um: Clean up linker script using standard macros.

    Signed-off-by: Tim Abbott <tabbott@ksplice.com>
    Cc: Jeff Dike <jdike@addtoit.com>
    Cc: user-mode-linux-devel@lists.sourceforge.net
    Acked-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 43c1b7afe756beb0dc5073195916d54ac41e7546
fe33dda7c1b15c61a6a65195cc6522beb25e7ba2 M      arch

Cheers,
//richard
