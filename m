Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbXINNsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbXINNsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXINNsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:48:07 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:41473 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXINNsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:48:04 -0400
In-Reply-To: <adaodg7ocrh.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/12] IB/ehca: Add 1 is not longer needed because of firmware
 interface change
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF628247C3.FB0AFE13-ONC1257355.005E8356-C1257356.004BCE85@de.ibm.com>
Date: Fri, 14 Sep 2007 15:48:00 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 14/09/2007 15:48:01,
	Serialize complete at 14/09/2007 15:48:01
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 12.09.2007 22:21:54:

> What happens if someone runs the new driver with older firmware?  Or
> what if someone upgrades the firmware without updating the driver?

Thanks for pointing our noses to this. Your comment triggered some further 
internal discussions about the meaning of the values for the current 
system implementation. We'll think this one over again and repost the 
final solution in time for 2.6.24-rc1.

If the rest of this patchset is okay with you, could you apply it and 
leave out this one patch? The patchset will apply cleanly without it.

Thanks,
  Joachim
