Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZJFR5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZJFR5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZJFR5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbZJFR5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:57:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
In-Reply-To: Oleg Nesterov's message of  Tuesday, 6 October 2009 15:37:32 +0200 <20091006133732.GB8628@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com>
	<20091003171029.GA30442@us.ibm.com>
	<20091004021844.GA21006@redhat.com>
	<20091004021918.GB21006@redhat.com>
	<20091006073100.4184128@magilla.sf.frob.com>
	<20091006133732.GB8628@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20091006175705.6547A22@magilla.sf.frob.com>
Date: Tue,  6 Oct 2009 10:57:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps, we should add the comment to explain that both SI_FROMUSER()
> and si_fromuser() are only valid in the sending pathes.

Yes.  Also now that you put them both in a sentence together, it is clear
that it is insane to have two different things with those two names that
differ only in capitalization.


Thanks,
Roland
