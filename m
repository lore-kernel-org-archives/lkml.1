Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYFFN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYFFN7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYFFN7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:59:12 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:41377 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYFFN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:59:11 -0400
To: Scott Wiersdorf <scott@perlcode.org>
Cc: Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
From: Andi Kleen <andi@firstfloor.org>
References: <20080605194334.GA56830@perlcode.org>
Date: Fri, 06 Jun 2008 15:59:09 +0200
In-Reply-To: <20080605194334.GA56830@perlcode.org> (Scott Wiersdorf's message of "Thu, 5 Jun 2008 13:43:35 -0600")
Message-ID: <87d4muu0k2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jun 2008 13:51:59.0882 (UTC) FILETIME=[7DE2FEA0:01C8C7DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wiersdorf <scott@perlcode.org> writes:

> This adds a USR1 signal handler to getdelays.c, which causes getdelays
> to close its logfile and reopen it (if '-w logfile' is
> specified). This is useful in situations when getdelays is running for
> a long time (i.e, the log file growing) and you need to rotate the
> logs but don't want to lose any log data.

You could do the same by sending SIGSTOP; copy file; truncate file; SIGCONT

-Andi
