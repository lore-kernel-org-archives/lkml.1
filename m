Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYEXJ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYEXJ0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 05:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYEXJZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 05:25:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39467 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYEXJZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 05:25:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18487.57106.644612.157155@harpo.it.uu.se>
Date: Sat, 24 May 2008 11:25:38 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Only print "Decompressing Linux" etc when 'noisy' is passed.
In-Reply-To: <1211579968-15227-2-git-send-email-krh@redhat.com>
References: <1211579968-15227-1-git-send-email-krh@redhat.com>
	<1211579968-15227-2-git-send-email-krh@redhat.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=?utf-8?q?Kristian=20H=C3=B8gsberg?= writes:
 > Signed-off-by: Kristian Høgsberg <krh@redhat.com>
 > ---
 >  arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
 >  1 files changed, 27 insertions(+), 3 deletions(-)

How is this an improvement? What bug does it fix?
Is there any evidence that these messages are harmful
for end-users?

All this accomplishes is to make early boot failures harder
to debug.
