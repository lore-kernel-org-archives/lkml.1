Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbXGJL0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbXGJL0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXGJL0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:26:15 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46756 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXGJL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:26:14 -0400
In-Reply-To: <adazm25w998.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] IB/ehca: Set SEND_GRH flag for all non-LL UD QPs on eHCA2
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF42327D02.A1FE96AF-ONC1257314.003E9788-C1257314.003EE7E8@de.ibm.com>
Date: Tue, 10 Jul 2007 13:26:10 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 10/07/2007 13:26:11,
	Serialize complete at 10/07/2007 13:26:11
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 09.07.2007 23:35:31:

> Out of curiousity, does this mean that a GRH will be sent on all UD
> messages (for non-LL QPs)?

No - the bit instructs the hardware to fetch the GRH parts of the QP 
context.
The GRH will only be used if the WQE says so.

Joachim
