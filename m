Return-Path: <linux-kernel-owner+w=401wt.eu-S937052AbXGUIXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937052AbXGUIXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbXGUIXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:23:16 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:10306 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbXGUIXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:23:14 -0400
In-Reply-To: <adabqe67632.fsf@cisco.com>
Subject: Re: [ofa-general] [PATCH 1/5] ehca: Supports large page MRs
To: Roland Dreier <rdreier@cisco.com>
Cc: general-bounces@lists.openfabrics.org,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org,
       Stefan Roscher <stefan.roscher@de.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFDBEFA17C.9FE35C61-ONC125731F.002DE742-C125731F.002E0843@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Sat, 21 Jul 2007 10:22:54 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 21/07/2007 10:23:03
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland!
> I applied this, but I agree with checkpatch.pl:
>
>  > WARNING: externs should be avoided in .c files
>  > #227: FILE: drivers/infiniband/hw/ehca/ehca_mrmw.c:67:
>  > +extern int ehca_mr_largepage;
>  >
>  > WARNING: externs should be avoided in .c files
>  > #949: FILE: drivers/infiniband/hw/ehca/hcp_if.c:753:
>  > +   extern int ehca_debug_level;
>
> if you need to use a variable in more than one .c file, put the extern
> declaration in a common header that's included everywhere you use the
> variable, including the .c file that it is defined in.  That way the
> compiler can see if you get confused about the type of the variable.
That's true.
> When you get a chance, please post a follow-on patch to fix this.
Sure thing. Will do that for rc2.
Thanks!
Nam

