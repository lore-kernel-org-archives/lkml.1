Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbYARNJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbYARNJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYARNIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:08:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57449 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYARNIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:08:53 -0500
Date: Fri, 18 Jan 2008 14:12:09 +0100
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
Message-ID: <20080118131209.GA16459@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu> <20080114212105.GB8903@linux-os.sc.intel.com> <20080115221758.GG2665@elte.hu> <20080115232115.GD8903@linux-os.sc.intel.com> <20080118120112.GB8583@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118120112.GB8583@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (AMD machines apparently don't need it 

That's not true -- we had AMD systems in the past with broken MTRRs for
large memory configurations too,  Mostly it was pre revE though.

-Andi
