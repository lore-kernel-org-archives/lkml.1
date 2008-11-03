Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYKCT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYKCT7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYKCT7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:59:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYKCT7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:59:01 -0500
Date: Mon, 3 Nov 2008 17:58:38 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103195838.GD32603@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	=?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
	mingo@elte.hu, srostedt@redhat.com, sandmann@daimi.au.dk,
	linux-kernel@vger.kernel.org
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <1225742189.7803.1631.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225742189.7803.1631.camel@twins>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 03, 2008 at 08:56:29PM +0100, Peter Zijlstra escreveu:
> fwiw, this is one amazing subject line.. ;-)

Too much for "subject says it all." 8)

- Arnaldo
