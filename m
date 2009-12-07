Return-Path: <linux-kernel-owner+w=401wt.eu-S965163AbZLGWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbZLGWD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965130AbZLGWD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:03:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:13132 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965103AbZLGWD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:03:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,357,1257148800"; 
   d="scan'208";a="576498058"
Subject: Re: linux-next: net/kbuild trees build failure
From: reinette chatre <reinette.chatre@intel.com>
To: Michal Marek <mmarek@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1D76B1.6070601@suse.cz>
References: <20091207200317.57820f0a.sfr@canb.auug.org.au>
	 <20091207114158.GA2428@merkur.ravnborg.org> <4B1CF39A.5050806@suse.cz>
	 <20091207160903.GB18939@tuxdriver.com> <1260209537.4653.778.camel@rc-desk>
	 <4B1D76B1.6070601@suse.cz>
Content-Type: text/plain
Date: Mon, 07 Dec 2009 14:04:03 -0800
Message-Id: <1260223443.4653.794.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 13:42 -0800, Michal Marek wrote:
> It seems there is some misunderstanding.
> The original problem reported by Stephen was that linux/utsrelease.h was
> moved to generated/utsrelease.h in the kbuild tree (that commit also
> patched init/version.c and all other users known at that time). This
> change in kbuild broke the new iwlwifi in the net tree. Stephen attached
> the most obvious fix, i.e. change linux/utsrelease.h to
> generated/utsrelease.h in the iwlwifi source
> (http://lkml.org/lkml/2009/12/7/121). My suggestion was to let Stephen
> carry the fix in linux-next for now, and once one of the trees (kbuild
> or net) hits mainline, the other tree would apply Stephen's patch. Would
> that work for everyone?

I am not involved in the merging part and would thus not be the one
applying Stephen's patch. I would like the iwlwifi patch that uses
UTS_RELEASE as well as Stephen's fix to find it in the right place to go
in though (end up in linux-2.6).

> Now if someone wants to remove the DRV_VERSION macro from iwlwifi or rip
> the UTS_RELEASE part out of it, that would make this problem go away,
> but I don't think it's necessary _just_ because of the kbuild change.

This is perhaps something John and I should discuss separately.

Thank you

Reinette

