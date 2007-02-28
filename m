Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXB1W1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXB1W1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbXB1W1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:27:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXB1W1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:27:40 -0500
Message-ID: <45E601D9.1050503@redhat.com>
Date: Wed, 28 Feb 2007 17:27:37 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Albert Cahalan <acahalan@gmail.com>
Subject: PID entries in /proc sorted by number, not start time in 2.6.19
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with kernel 2.6.19, the process directories in
/proc are sorted by number. They were sorted by process
start time in 2.6.18 and earlier. This makes the output
of procps come out in that order too, pissing off users
who are used to the old way.

To reproduce:
	1. Wrap your PID numbers.
	2. Do ls -fl /proc
	3. Look at output of ps command.

Compare 2.6.18 to 2.6.19.

See also:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=230227

