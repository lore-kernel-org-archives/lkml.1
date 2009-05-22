Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZEVLqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZEVLqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZEVLqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:46:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6383 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZEVLqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:46:07 -0400
X-IronPort-AV: E=Sophos;i="4.41,233,1241409600"; 
   d="scan'208";a="52205638"
Subject: Re: [PATCH] swiotlb: make swiotlb allocation functions
	architecture-specific
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "jeremy@goop.org" <jeremy@goop.org>,
       "beckyb@kernel.crashing.org" <beckyb@kernel.crashing.org>,
       "okir@suse.de" <okir@suse.de>, "mingo@elte.hu" <mingo@elte.hu>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "xendevel@lists.xensource.com" <xendevel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090522200302R.fujita.tomonori@lab.ntt.co.jp>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	 <1242922528-5982-5-git-send-email-ian.campbell@citrix.com>
	 <20090522200302R.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 12:46:06 +0100
Message-ID: <1242992766.22654.279.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> On Thu, 21 May 2009 17:15:25 +0100
> Ian Campbell <ian.campbell@citrix.com> wrote:
> 
> > Some architectures need to allocate memory to be used as a swiotlb in
> > a special manner.
> 
> Hmm, what architectures need a special manner? I guess only Xen.

The x86 architecture, when running as a paravirtualised guest under Xen,
needs it. I guess ia64 might need it for similar reasons, I'm not sure.

How does the fact that x86-Xen is (currently) the only user invalidate
the requirement? You seem to have a knee-jerk reaction to anything which
might be useful to Xen and I really don't understand why that should be
the case.

We are talking about an initialisation path and we are not talking about
changes which completely obscure all meaning or anything. The semantics
of the API are pretty clear, I think.

Ian.


