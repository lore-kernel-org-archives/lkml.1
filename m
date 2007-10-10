Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbXJJVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbXJJVLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXJJVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:11:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:47098 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbXJJVLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:11:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,256,1188802800"; 
   d="scan'208";a="341636560"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: TPM driver changes to support multiple locality
Date: Wed, 10 Oct 2007 14:09:24 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628CB9403@scsmsx412.amr.corp.intel.com>
In-Reply-To: <27383.1192045583@turing-police.cc.vt.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TPM driver changes to support multiple locality
Thread-Index: AcgLdklDzSEVWzzDRSifb0a4f9wMMAACzmKg
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com> <27383.1192045583@turing-police.cc.vt.edu>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Oct 2007 21:09:27.0689 (UTC) FILETIME=[D7A87F90:01C80B81]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There will be no change in API. Driver will accept a parameter
"locality" and it will always operate on that locality. By default this
parameter will be 0 which is what current driver assumes.
Who is the maintainer for this driver?

-----Original Message-----
From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu] 
Sent: Wednesday, October 10, 2007 12:46 PM
To: Agarwal, Lomesh
Cc: linux-kernel@vger.kernel.org
Subject: Re: TPM driver changes to support multiple locality

On Tue, 09 Oct 2007 15:51:11 PDT, "Agarwal, Lomesh" said:
> Current TPM driver supports only locality 0. I am planning to add
> support so that it can access any locality. Locality parameter will be
> passed as parameter. Will this change be acceptable? If yes then I
will
> modify the driver and send the patch.

Make sure you extend the API in such a way that older userspace programs
that don't pass the new locality parameter still work correctly.
