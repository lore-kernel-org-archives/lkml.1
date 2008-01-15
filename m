Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYAOXIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYAOXIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYAOXIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:08:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34264 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYAOXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:08:36 -0500
Date: Wed, 16 Jan 2008 00:11:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       jesse.barnes@intel.com
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080115231140.GA5967@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu> <20080114212105.GB8903@linux-os.sc.intel.com> <20080115221758.GG2665@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115221758.GG2665@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> just to make sure i understood the attribute priorities right: we cannot 
> just mark it WB in the PAT and expect it to be write-back - the UC of 
> the MTRR will control?

There are different kinds of UC: UC+ and UC-. One controls the other doesn't.

-Andi
