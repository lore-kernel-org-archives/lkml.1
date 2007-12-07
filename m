Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXLGUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXLGUmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXLGUmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:42:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXLGUmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:42:07 -0500
Date: Fri, 7 Dec 2007 21:41:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com
Subject: Re: [PATCH 0/3] Unify segment headers
Message-ID: <20071207204102.GA25424@elte.hu>
References: <119704456265-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <119704456265-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> Hi,
> 
> In this patch, I unify segment_32.h and segment_64.h into segment.h 
> They have some common parts, but a considerable ammount of code still 
> has to be around ifdefs.
> 
> The only patch that is really important to paravirt is the first one, 
> that moves a paravirt definition into the common header. The other two 
> are just normal integration, and pretty much independent

thanks, i've picked them up for x86.git.

	Ingo
