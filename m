Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909Ab0ADUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0ADUrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740Ab0ADUrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:47:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab0ADUrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:47:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
 results	on s390x)
In-Reply-To: Martin Schwidefsky's message of  Monday, 4 January 2010 17:16:26 +0100 <20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
References: <1503844142.2061111261478093776.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<20100104155225.GA16650@redhat.com>
	<20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20100104204656.B2396D532@magilla.sf.frob.com>
Date: Mon,  4 Jan 2010 12:46:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The PER control registers only get reloaded on task switch. Can you test
> if this patch fixes your problem?

Long ago when I first worked with David Wilder on s390 arch code,
I remember we made this change.  It seems to have been forgotten
in the later rounds of reworking and merging.


Thanks,
Roland
