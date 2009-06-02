Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZFBBjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZFBBjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZFBBjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:39:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64981 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZFBBjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:39:35 -0400
Message-Id: <200906020139.n521dYP7002722@www262.sakura.ne.jp>
Subject: [PATCH] TOMOYO: Add garbage collector support. (v3)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 10:39:34 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 01062009 #2072025, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patchset adds garbage collector support for TOMOYO.
I replaced the cookie list approach with the refcounter approach.

[PATCH 1/5] Move sleeping operations to outside the semaphore.
[PATCH 2/5] Clarify lock protected section.
[PATCH 3/5] Simplify policy reader.
[PATCH 4/5] Replace tomoyo_save_name() with tomoyo_get_name()/tomoyo_put_name().
[PATCH 5/5] Add refcounter and garbage collector.

These patches are made for security-testing-2.6#next with a commit
b1338d199dda6681d9af0297928af0a7eb9cba7b (tomoyo: add missing call to
cap_bprm_set_creds) applied.

Regards.
