Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbZAFFOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbZAFFOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZAFFOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:14:11 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56663 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZAFFOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:14:10 -0500
Message-Id: <200901060514.n065E462074929@www262.sakura.ne.jp>
Subject: [PATCH] Add in_execve flag into task_struct.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 14:14:04 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 06012009 #1405241, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge,

James is now reviewing TOMOYO Linux patch and he is caring about
your comment below.

Serge E. Hallyn wrote:
> I don't like the 'in_exec' bit in the task_struct, but adding LSM hooks
> to let just TOMOYO mark whether you're in exec seems even uglier.

Let me (once again) ask your comment on 'in_exec' approach
originally suggested by David Howells ( http://lkml.org/lkml/2008/10/2/127 ).
