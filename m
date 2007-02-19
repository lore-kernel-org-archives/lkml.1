Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXBSTnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXBSTnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbXBSTnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:43:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44311 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbXBSTnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:43:50 -0500
Subject: Re: [RFC][PATCH][1/4] RSS controller setup
From: Matthew Helsley <matthltc@us.ibm.com>
To: balbir@in.ibm.com
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       svaidy@linux.vnet.ibm.com, devel@openvz.org
In-Reply-To: <45D98654.2020005@in.ibm.com>
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
	 <20070219065026.3626.36882.sendpatchset@balbir-laptop>
	 <20070219005727.da2acdab.akpm@linux-foundation.org>
	 <6599ad830702190118r20b477d3q254c167c2fc2732@mail.gmail.com>
	 <45D98654.2020005@in.ibm.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 11:43:46 -0800
Message-Id: <1171914227.29415.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 16:43 +0530, Balbir Singh wrote:
> Paul Menage wrote:
> > On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:

<snip>

> > Hmm, I don't appear to have documented this yet, but I think a good
> > naming scheme for container files is <subsystem>.<whatever> - i.e.
> > these should be memctlr.usage and memctlr.limit. The existing
> > grandfathered Cpusets names violate this, but I'm not sure there's a
> > lot we can do about that.
> > 
> 
> Why <subsystem>.<whatever>, dots are harder to parse using regular
> expressions and sound DOS'ish. I'd prefer "_" to separate the
> subsystem and whatever :-)

"_" is useful for names with "spaces". Names like mem_controller. "."
seems reasonable despite its regex nastyness. Alternatively there's
always ":".

<snip>

Cheers,
	-Matt Helsley

