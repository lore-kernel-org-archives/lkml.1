Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXKSWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXKSWBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXKSWBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:01:05 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53684 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXKSWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:01:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 0/4] proc: Cleanup status files.
References: <20071117183109.GA2605@tv-sign.ru>
Date: Mon, 19 Nov 2007 14:59:57 -0700
In-Reply-To: <20071117183109.GA2605@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 17 Nov 2007 21:31:09 +0300")
Message-ID: <m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There is a long standing ugliness with /proc/<pid>/stat,
/proc/<pid>/statm, and /proc/<pid>/status that they do not
use the seqfile API.

In addition they are currently reporting pids in the pid namespace
of the current task instead of the pid namespace with which proc
was mounted which is confusing.

This patch series first build the infrastructure to allow these
problems to be fixed and then it converts the individual proc
status files.

Eric

