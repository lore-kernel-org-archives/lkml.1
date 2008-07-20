Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYGTQhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYGTQhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbYGTQhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:37:01 -0400
Received: from nebensachen.de ([195.34.83.29]:58229 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbYGTQhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:37:00 -0400
X-Hashcash: 1:20:080720:rjw@sisk.pl::fWerNLAaHEQBQQDt:0000002A8a
X-Hashcash: 1:20:080720:linux-kernel@vger.kernel.org::FPr0OuCvkx1iVBVp:0000000000000000000000000000000007s1c
From: Elias Oltmanns <eo@nebensachen.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Freezer: How to handle timers?
Date: Sun, 20 Jul 2008 18:36:40 +0200
Message-ID: <87fxq4a4x3.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

am I right in thinking that timers set by mod_timer() will not fire
once suspend_freeze_processes() has completed? If so, what options do I
have to make sure that either suspending will be delayed until my timer
has expired, or the timeout callback will be called as part of the
suspend sequence even if the timer has not expired yet?

Thanks in advance,

Elias
