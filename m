Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYCLHPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYCLHPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYCLHPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:15:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45505 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbYCLHPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:15:33 -0400
Date: Wed, 12 Mar 2008 08:14:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>, shai@scalex86.org
Subject: Re: 2.6.25-rc5-mm1 (paravirt/vsmp/no PCI)
Message-ID: <20080312071425.GA21891@elte.hu>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <20080311100955.ca113f90.randy.dunlap@oracle.com> <47D6CD04.8060303@goop.org> <20080312001040.GA6434@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312001040.GA6434@localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Would anyone have objection to have PARAVIRT depend on PCI, since the 
> vsmp paravirt bits depend on PCI cfg space to determine if the system 
> is vsmp?  If not, this patch would suffice.

hm, that's not a good idea - there's nothing in lguest, Xen and even KVM 
that is inherently tied to PCI.

	Ingo
