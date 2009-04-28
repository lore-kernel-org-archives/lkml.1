Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbZD1PPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbZD1PPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762235AbZD1PNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:13:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42338 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761989AbZD1PNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:13:01 -0400
Subject: Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, fenkes@de.ibm.com, raisch@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com, hnguyen@de.ibm.com
In-Reply-To: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 08:12:51 -0700
Message-Id: <1240931572.29485.77.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 17:16 +0200, Stefan Roscher wrote:
> From: Anton Blanchard <antonb at au1.ibm.com>
> 
> To improve performance of driver ressource allocation,
> replace the vmalloc() call with kmalloc().

Just curious, but how big are these allocations?  Why was vmalloc() even
ever used if we know they'll be small?

-- Dave

