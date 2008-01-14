Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYANVZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYANVZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYANVZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:25:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38668 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYANVZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:25:13 -0500
Date: Mon, 14 Jan 2008 22:28:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       jesse.barnes@intel.com
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080114212811.GD19102@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu> <20080114212105.GB8903@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114212105.GB8903@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Time to resurrect Jesse's old patches 
> i386-trim-memory-not-covered-by-wb-mtrrs.patch(which was in -mm sometime back)

They broke booting on my AMD QuadCore system here. Never quite figured
out what the problem was unfortunately.

-Andi
