Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbYJJNcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbYJJNcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbYJJNci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:32:38 -0400
Received: from ns.firmix.at ([62.141.48.66]:6026 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbYJJNci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:32:38 -0400
Subject: Re: dup2() vs dup3() inconsistency when
From: Bernd Petrovitsch <bernd@firmix.at>
To: mtk.manpages@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ulrich Drepper <drepper@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <cfd18e0f0810100615o1ffd32d6u33603f93c4739171@mail.gmail.com>
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
	 <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com>
	 <48EE6CD6.10007@zytor.com> <48EE6F22.5070306@redhat.com>
	 <48EE703C.7070901@zytor.com>
	 <cfd18e0f0810092204n50f88887t7776133620eff75b@mail.gmail.com>
	 <1223640571.8832.60.camel@spike.firmix.at>
	 <cfd18e0f0810100515u6f510cbat880020bae14aee71@mail.gmail.com>
	 <1223643764.8832.67.camel@spike.firmix.at>
	 <cfd18e0f0810100615o1ffd32d6u33603f93c4739171@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 10 Oct 2008 15:31:56 +0200
Message-Id: <1223645516.8832.73.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.336 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.336 required=5
X-Spam-Score: -2.336 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 15:15 +0200, Michael Kerrisk wrote:
> On Fri, Oct 10, 2008 at 3:02 PM, Bernd Petrovitsch <bernd@firmix.at> wrote:
[....]
> >> but to eliminate the blemish in its design in the new dup3() (since we
> >> have alrady eliminated one other blemish).
> >
> > FWIW I consider the automatic close() in dup2() a feature (if only that
> > it avoids an additional system call).
> 
> Exploiting this "feature" can hide real errors that would be detected
> if one does an explicit close().  (See the dup2 man page.)

If someone is interested in the return value of the automatic close(),
he/she can call close() anyways and check the the result.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


