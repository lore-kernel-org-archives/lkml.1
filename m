Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbXGQGap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbXGQGap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXGQGah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:30:37 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:4518 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbXGQGaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:30:35 -0400
In-Reply-To: <adatzs3u1sa.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/10] IB/ehca: Support large page MRs
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF38142F5F.0D12E609-ONC125731B.00239A1F-C125731B.0023C7C0@de.ibm.com>
Date: Tue, 17 Jul 2007 08:29:54 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 17/07/2007 08:30:09,
	Serialize complete at 17/07/2007 08:30:09
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 17.07.2007 05:50:13:

>  > > Why the module parameter?  Is there any reason a user would want to
>  > > turn this off?  Or conversely, why is it off by default?
>  > 
>  > We're pretty confident this new feature works, but as with all new 
and 
>  > possibly experimental features, there are chances it might explode 
your 
>  > machine when activated. So, like with the scaling code, we want the 
user 
>  > to make the conscious decision of using this code instead of 
activating it 
>  > by default.
> 
> OK, I guess.  So can we expect to, say, change the default to turning
> it on for 2.6.24 and remove the option entirely (so it's always on) in
> 2.6.25?

Deal.

Joachim
