Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZBKQeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZBKQeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZBKQdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:33:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbZBKQdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:33:50 -0500
Date: Wed, 11 Feb 2009 17:33:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Message-ID: <20090211163331.GA4251@elte.hu>
References: <20090211214639.C3D0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27780.1234356078@redhat.com> <31230.1234357767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31230.1234357767@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw:

include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards 
qualifiers from pointer target type
include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards 
qualifiers from pointer target type
include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards 
qualifiers from pointer target type
include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards 
qualifiers from pointer target type
include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards 
qualifiers from pointer target type

probably unrelated.

	Ingo
