Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZJNTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZJNTb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZJNTb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:31:58 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:16587
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759115AbZJNTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:31:57 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2009 15:31:57 EDT
X-IronPort-AV: E=Sophos;i="4.44,561,1249250400"; 
   d="scan'208";a="36327666"
Date: Wed, 14 Oct 2009 21:22:46 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Leonidas ." <leonidas137@gmail.com>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to check whether executing in atomic context?
Message-ID: <20091014192246.GC5755@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	"Leonidas ." <leonidas137@gmail.com>,
	Gleb Natapov <gleb@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com> <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com> <20091014101336.GA25108@redhat.com> <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com> <4AD60CD1.4000804@s5r6.in-berlin.de> <f22d86810910141211u1f83f57fibfaa5ee19a39813f@mail.gmail.com> <4AD6235B.8090905@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD6235B.8090905@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter, le Wed 14 Oct 2009 21:15:39 +0200, a écrit :
> > I am not aware of any Linux kernel module which can comply to this
> > kind of use case, what would be the most optimal thing to do here?
> 
> And preallocation is not feasible either?

Or deferring work to a kernel thread.

Samuel
