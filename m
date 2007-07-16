Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbXGPUgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbXGPUgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXGPUgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:36:17 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:54971 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXGPUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:36:17 -0400
In-Reply-To: <adaejj8w9t0.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] IB/ehca: use common error code mapping instead of
 specific ones
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFA7C8E574.345A8A38-ONC125731A.0071195A-C125731A.00713074@de.ibm.com>
Date: Mon, 16 Jul 2007 22:35:25 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 16/07/2007 22:35:50,
	Serialize complete at 16/07/2007 22:35:50
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 16.07.2007 19:14:03:

> applied, but as a further cleanup it seems that ehca2ib_return_code()
> should be moved into a .c file and moved out of line -- I think it
> would probably shrink the compiled code quite a bit, and as far as I
> can see it is never used in the data path where the function call
> overhead would matter at all.

Sounds reasonable; I'll put it in the next patch series.

Joachim
