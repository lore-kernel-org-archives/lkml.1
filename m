Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbXEQCqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbXEQCqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbXEQCpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:45:53 -0400
Received: from ns1.suse.de ([195.135.220.2]:49845 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbXEQCpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:45:52 -0400
From: Neil Brown <neilb@suse.de>
To: "Jeff Zheng" <Jeff.Zheng@endace.com>
Date: Thu, 17 May 2007 12:45:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17995.49602.427417.500049@notabene.brown>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
In-Reply-To: message from Jeff Zheng on Thursday May 17
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 17, Jeff.Zheng@endace.com wrote:
> 
> > The only difference of any significance between the working 
> > and non-working configurations is that in the non-working, 
> > the component devices are larger than 2Gig, and hence have 
> > sector offsets greater than 32 bits.
> 
> Do u mean 2T here?, but in both configuartion, the component devices are
> larger than 2T (2.25T&5.5T).

Yes, I meant 2T, and yes, the components are always over 2T.  So I'm
at a complete loss.  The raid0 code follows the same paths and does
the same things and uses 64bit arithmetic where needed.

So I have no idea how there could be a difference between these two
cases.  

I'm at a loss...

NeilBrown
