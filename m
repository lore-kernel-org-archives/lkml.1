Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZELDUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZELDUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZELDU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:20:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbZELDU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:20:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] wait_task_* cleanups V2
In-Reply-To: Vitaly Mayatskikh's message of  Monday, 11 May 2009 15:25:49 +0200 <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
X-Windows: you'll envy the dead.
Message-Id: <20090512031932.2FD67FC35D@magilla.sf.frob.com>
Date: Mon, 11 May 2009 20:19:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg is out this week, and we should let him react.
It looks generally good to me.

Can't the wo_stat handling be rolled into copy_wait_opts_to_user too?
Also it looks like every(?) caller does:
	if (!retval)
		retval = pid;
so why not roll that into copy_wait_opts_to_user too?


Thanks,
Roland
