Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZGAV7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZGAV7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZGAV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:58:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZGAV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:58:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
In-Reply-To: Sukadev Bhattiprolu's message of  Wednesday, 1 July 2009 14:48:05 -0700 <20090701214805.GA25734@us.ibm.com>
References: <20090701073140.GA14284@us.ibm.com>
	<20090701074654.A6C6321D57@magilla.sf.frob.com>
	<20090701082452.GA3297@redhat.com>
	<20090701214805.GA25734@us.ibm.com>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20090701215833.876DA404FD@magilla.sf.frob.com>
Date: Wed,  1 Jul 2009 14:58:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, that's fine.  Since Oleg's pointed out that there is indeed no way to
avoid the leak in some global-init uses, it is fine to have a comment that
says that global init problems are part of the reason to outlaw this usage.
I just objected to a change that was really for container init but said it
was only to fix something different.


Thanks,
Roland
