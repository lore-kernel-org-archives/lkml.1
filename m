Return-Path: <linux-kernel-owner+w=401wt.eu-S1764743AbXGRRGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764743AbXGRRGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXGRRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:06:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:2564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbXGRRGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:06:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,551,1175497200"; 
   d="scan'208";a="107494229"
Message-ID: <469E4876.7020805@ichips.intel.com>
Date: Wed, 18 Jul 2007 10:05:58 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Sean Hefty <sean.hefty@intel.com>
CC: "'Roland Dreier'" <rdreier@cisco.com>, Or Gerlitz <or.gerlitz@gmail.com>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
References: <000001c7c8fc$360eec90$5dcc180a@amr.corp.intel.com>
In-Reply-To: <000001c7c8fc$360eec90$5dcc180a@amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We will have a better idea of the issues and possible solutions once the QoS
> spec is released, and we can hold discussions on it.  I will be working more
> details on QoS enhancements starting in the next couple of weeks. 

Based on discussions so far, maybe the best path forward from here is to
delay until 2.6.24.  This will let us add this version to OFED 1.3 for
more widespread testing, plus give us the time that we need to come up
with a plan to integrate QoS with the local SA.  I don't think we'll
have a final implementation for QoS support by that time, but at least
we'll have a better idea of the problems.

These patches are based on the same design used with OFED 1.2, but a
fair number of lines of code still changed, plus it added InformInfo 
registration.  I don't believe anyone other than me has tested these 
patches with the local SA enabled.  It's typically running on my 
systems, but because it automatically fails over to standard SA queries, 
it would be easy for me to miss problems.

- Sean
