Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYGaKl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYGaKl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYGaKlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:41:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYGaKlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:41:17 -0400
Date: Thu, 31 Jul 2008 12:39:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH] xen: xen: compile irq functions without -pg for ftrace
Message-ID: <20080731103955.GH488@elte.hu>
References: <488E15C5.3070902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E15C5.3070902@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> For some reason I managed to miss a bunch of irq-related functions 
> which also need to be compiled without -pg when using ftrace.  This 
> patch moves them into their own file, and starts a cleanup process 
> I've been meaning to do anyway.

applied to tip/x86/xen - thanks Jeremy.

	Ingo
