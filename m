Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbXJHWgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbXJHWgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXJHWf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:35:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:46883 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXJHWfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:35:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,244,1188802800"; 
   d="scan'208";a="339657359"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: parallel networking
Date: Mon, 8 Oct 2007 15:35:53 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32903BC14B3@orsmsx414.amr.corp.intel.com>
In-Reply-To: <20071008.153353.58431888.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: parallel networking
Thread-Index: AcgJ+1AYIPsS107gTaeCuUybicteKgAABjOA
References: <470A3D24.3050803@garzik.org><20071008.141154.107706003.davem@davemloft.net><1191882618.4373.99.camel@localhost> <20071008.153353.58431888.davem@davemloft.net>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "David Miller" <davem@davemloft.net>, <hadi@cyberus.ca>
Cc: <jeff@garzik.org>, <krkumar2@in.ibm.com>, <johnpol@2ka.mipt.ru>,
       <herbert@gondor.apana.org.au>, <kaber@trash.net>,
       <shemminger@linux-foundation.org>, <jagana@us.ibm.com>,
       <Robert.Olsson@data.slu.se>, <rick.jones2@hp.com>, <xma@us.ibm.com>,
       <gaagaan@gmail.com>, <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <mingo@elte.hu>, <mchan@broadcom.com>, <general@lists.openfabrics.org>,
       <kumarkr@linux.ibm.com>, <tgraf@suug.ch>, <randy.dunlap@oracle.com>,
       <sri@us.ibm.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Oct 2007 22:35:54.0161 (UTC) FILETIME=[9635D210:01C809FB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Multiply whatever effect you think you might be able to 
> measure due to that on your 2 or 4 way system, and multiple 
> it up to 64 cpus or so for machines I am using.  This is 
> where machines are going, and is going to become the norm.

That along with speeds going to 10 GbE with multiple Tx/Rx queues (with
40 and 100 GbE under discussion now), where multiple CPU's hitting the
driver are needed to push line rate without cratering the entire
machine.

-PJ Waskiewicz
