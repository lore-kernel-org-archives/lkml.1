Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbZA2PyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbZA2PyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZA2PyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:54:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38704 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZA2PyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:54:05 -0500
Date: Thu, 29 Jan 2009 10:53:42 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       utrace-devel@redhat.com, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Neil Horman <nhorman@tuxdriver.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090129155341.GB20679@redhat.com>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere> <20090127225048.GA4652@nowhere> <20090129140451.GM24391@elte.hu> <c62985530901290629i168ac12cjc4b22140caceff58@mail.gmail.com> <20090129143120.GS24391@elte.hu> <c62985530901290640j10e63127s59ce22e860a508f8@mail.gmail.com> <20090129150934.GF6512@elte.hu> <c62985530901290734i26c5b664m2b0342b29cc95807@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901290734i26c5b664m2b0342b29cc95807@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jan 29, 2009 at 04:34:46PM +0100, Frédéric Weisbecker wrote:
> 2009/1/29 Ingo Molnar <mingo@elte.hu>:
> [...]
> >> > sure - how do the minimal bits/callbacks look like which enable syscall
> >> > tracing?

> I know you are talking about the only necessary bits from utrace to
> have the syscalls tracing.  But I can't answer you better than would
> the utrace people.  And actually I'm not sure the utrace bits for
> syscall tracing can be isolated from the rest of its core.

My understanding is that the parts of utrace that remain out-of-tree
are relatively integrated, and just present the programmatic callback
API to the already merged "tracehook" layer.

- FChE
