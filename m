Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZD1QDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZD1QDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbZD1QCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:02:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41388 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbZD1QCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:02:50 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
Date: Tue, 28 Apr 2009 18:02:47 +0200
User-Agent: KMail/1.9.9
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>,
       fenkes@de.ibm.com, raisch@de.ibm.com, alexschm@de.ibm.com,
       stefan.roscher@de.ibm.com, hnguyen@de.ibm.com
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com> <1240931572.29485.77.camel@nimitz>
In-Reply-To: <1240931572.29485.77.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904281802.47809.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009 05:12:51 pm Dave Hansen wrote:
> On Tue, 2009-04-21 at 17:16 +0200, Stefan Roscher wrote:
> > From: Anton Blanchard <antonb at au1.ibm.com>
> > 
> > To improve performance of driver ressource allocation,
> > replace the vmalloc() call with kmalloc().
> 
> Just curious, but how big are these allocations?  Why was vmalloc() even
> ever used if we know they'll be small?
> 
> -- Dave
> 
> 

The theoretical maximum size can be 512k, but for common queue pairs 
less than 128k is used.Because of the theoretical maximum we implemented
vmalloc() first, but recognized a huge performance impact.

-- Stefan 

