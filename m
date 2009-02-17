Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZBQT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZBQT7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZBQT7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:59:45 -0500
Received: from gw.goop.org ([64.81.55.164]:36729 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZBQT7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:59:45 -0500
Message-ID: <499B1729.5040802@goop.org>
Date: Tue, 17 Feb 2009 11:59:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Junio C Hamano <gitster@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>
Subject: [PATCH] Add *.rej to .gitignore
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*.rej files really are unwanted.  If there are any .rej files, they can be found by
some other means (perhaps git itself could warn when committing with *.rej files present,
or add some distinct notion of "ignored files" vs "never commit" files).

(This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/.gitignore b/.gitignore
index 869e1a3..3d56938 100644
--- a/.gitignore
+++ b/.gitignore
@@ -62,5 +62,6 @@ cscope.*
 ncscope.*
 
 *.orig
+*.rej
 *~
 \#*#


