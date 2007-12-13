Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXLMVgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXLMVgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbXLMVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:35:58 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:3509 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342AbXLMVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:35:56 -0500
In-Reply-To: <78C9135A3D2ECE4B8162EBDCE82CAD7702B14004@nekter>
To: "Caitlin Bestler" <Caitlin.Bestler@neterion.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>,
       "OF-General" <general@lists.openfabrics.org>,
       "LKML" <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       "Or Gerlitz" <ogerlitz@voltaire.com>,
       "Roland Dreier" <rdreier@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: RE: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related
 hCalls on POWER5
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD36374CC.9307FC29-ONC12573B0.00763BCF-C12573B0.0076A3D3@de.ibm.com>
Date: Thu, 13 Dec 2007 22:35:52 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 13/12/2007 22:35:53,
	Serialize complete at 13/12/2007 22:35:53
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Caitlin Bestler" <Caitlin.Bestler@neterion.com> wrote on 13.12.2007 
22:08:34:

> To clarify, an FMR Work Request is simply posted to the SendQ like
> any other Work Request (of course the QP has to be privileged, or
> it will complete in error). An SQ Post should never block.

This would require hardware support, wouldn't it? eHCA2 doesn't have this 
kind of support, so FMR WRs are not an option here.

J.
