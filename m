Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbXBMH6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbXBMH6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXBMH6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:58:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbXBMH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:58:13 -0500
Subject: Re: [PATCH 1/3] Introducing cpuidle: core cpuidle infrastructure
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adam Belay <abelay@novell.com>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
In-Reply-To: <20070213012201.GA27685@redhat.com>
References: <20070212103925.A12078@unix-os.sc.intel.com>
	 <20070213012201.GA27685@redhat.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 08:58:09 +0100
Message-Id: <1171353489.12771.42.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The only differentiator that I can think of would be latency, but that seems
> to be a) covered in a different tunable, and b) probably wouldn't affect
> most people enough where it matters.
> 

and for latency the kernel already has a policy thing that tracks the
maximum latency allowed.... if we need to give the user a knob to shoot
himself into the foot with that one should probably be exported instead
(although I'm still convinced it's a mistake since our beloved userspace
WILL abuse it in the most unimaginable ways)

