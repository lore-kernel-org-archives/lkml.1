Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXLLPwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXLLPwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXLLPwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:52:12 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:26980 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbXLLPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:52:10 -0500
In-Reply-To: <475FD0A1.3090304@voltaire.com>
References: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com> <475FD0A1.3090304@voltaire.com>
Subject: Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: Arnd Bergmann <arnd@arndb.de>, OF-General <general@lists.openfabrics.org>,
       Joachim Fenkes <FENKES@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Roland Dreier <rdreier@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF2694B462.1504C1FC-ONC12573AF.0056AAC0-C12573AF.0056F862@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Wed, 12 Dec 2007 17:02:23 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 12/12/2007 16:52:07
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or Gerlitz <ogerlitz@voltaire.com> wrote on 12.12.2007 13:14:25:

> Joachim Fenkes wrote:
> > Roland Dreier <rdreier@cisco.com> wrote on 10.12.2007 22:47:37:
>
> >> It's an optional device feature, so this should be OK
> >> (although the iSER driver currently seems to depend on a device
> >> supporting FMRs, which is probably going to be a problem with iWARP
> >> support in the future anyway).
>
> > I don't feel very well with removing code from the driver that iSER
seems
> > to depend on. Are there plans to fix this in iSER?
>
> What is the fix you suggest, to add a device query that tells you for
> which verbs the documentation does not apply? or enhance the code of the
>   map_phys_fmr verb within the ehca driver to return error if called
> from non-sleepable context?

Roland,
what is your suggestion here?

We could implement both versions Or is proposing, but having both
at the same time sound like overkill.

Christoph R.

