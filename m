Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYC1ASc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYC1ASc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYC1ASZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:18:25 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:9304 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYC1ASY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=je+EunjzosySSIBIB0oMwkj4pfLpg8j5ghWSVpG9gqoPN5+kP6ZA3X9Ome+jWff3WUhHeUanr66FhijViZNrX82sBo1aU+K65KaFe24ClQSv0o1RQCSNU1yZPkW+k0pSW6e5Cd3NT51RkG/xIZbEYdWhxn2SvYdXCdeKmhj/0ZI=
Date: Thu, 27 Mar 2008 21:18:04 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-ID: <20080328001804.GA11075@localhost.ift.unesp.br>
References: <200803272353.51901.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803272353.51901.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27.Mar'08 at 23:53:50 +0100, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> [...]
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10343
> Subject		: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?) (bisected)
> Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> Date		: 2008-03-23 00:47 (5 days old)
> References	: http://lkml.org/lkml/2008/3/22/211
> Handled-By	: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This regression is already solved. The patch which caused this problem 
was reverted by Andrew Morton in 4dd4b920218326231156c7991ce5b94afad841c3.
