Return-Path: <linux-kernel-owner+w=401wt.eu-S933871AbXLMWAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbXLMWAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933815AbXLMV7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:59:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:53228 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806AbXLMV7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:59:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="340626483"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Caitlin Bestler'" <Caitlin.Bestler@neterion.com>,
       "Joachim Fenkes" <FENKES@de.ibm.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Roland Dreier" <rdreier@cisco.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
References: <469958e00712131122s661dd970ud359389e1c6637d4@mail.gmail.com><OFD5B7D5E6.3538DC2A-ONC12573B0.0072D42A-C12573B0.00735730@de.ibm.com> <78C9135A3D2ECE4B8162EBDCE82CAD7702B14004@nekter>
Subject: RE: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: SerializeHCA-related hCalls on POWER5
Date: Thu, 13 Dec 2007 13:48:40 -0800
Message-ID: <000301c83dd1$ec49d520$9b37170a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <78C9135A3D2ECE4B8162EBDCE82CAD7702B14004@nekter>
Thread-Index: Acg9y1HXDpcQP339RlC+xsY7pB+iFgAAAqMAAAFVZvA=
X-OriginalArrivalTime: 13 Dec 2007 21:48:44.0302 (UTC) FILETIME=[EEBF1AE0:01C83DD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>To clarify, an FMR Work Request is simply posted to the SendQ like
>any other Work Request (of course the QP has to be privileged, or
>it will complete in error). An SQ Post should never block.

FMR's as defined by the IB spec and that created by Mellanox are not the same.
They, unfortunately, use the same name and acronym only.  Mellanox FMRs use an
API that is more like that of standard MRs. 

- Sean

