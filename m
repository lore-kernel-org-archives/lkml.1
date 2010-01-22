Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978Ab0AVQnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0AVQnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456Ab0AVQnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:43:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:33888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753797Ab0AVQnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:43:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gloNgufZgPkqdjEZHmFjn+tnaTu+2usH8Rx6lnA
	a4P2O/kw2PWY9B
Subject: Re: [PATCH 1/2] perf symbols: Fix inverted logic for showing
 kallsyms as the source of symbols
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1264178102-4203-1-git-send-email-acme@infradead.org>
References: <1264178102-4203-1-git-send-email-acme@infradead.org>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 17:43:28 +0100
Message-Id: <1264178608.5935.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.69999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 14:35 -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Only if we parsed /proc/kallsyms (or a copy found in the buildid cache)
> we should set the dso long name to "[kernel.kallsyms]".

Yup, works just as well as my busted one :)

	-Mike

