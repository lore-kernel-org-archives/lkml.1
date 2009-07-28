Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZG1ONq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZG1ONq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZG1ONp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:13:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZG1ONo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:13:44 -0400
Date: Tue, 28 Jul 2009 11:13:31 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to
	/etc/perfconfig/symbols.skip
Message-ID: <20090728141331.GH28349@ghostprotocols.net>
References: <20090728001041.GG28349@ghostprotocols.net> <20090728031820.GH5147@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728031820.GH5147@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 28, 2009 at 05:18:21AM +0200, Frederic Weisbecker escreveu:
> On Mon, Jul 27, 2009 at 09:10:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > This also paves the way to add more symbol lists to be filtered out,
> > spinlock anyone?

> I guess it would be nice to also provide a way for non-privileged users
> to tune it.
 
> May be /etc/perfconfig/ and also ~/perfconfig/ ?

perf will have the same configuration system that git has, so the answer
is yes, your suggestion will be implemented soon.

- Arnaldo
