Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbZE2PZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbZE2PZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759542AbZE2PZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:25:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:30294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210AbZE2PZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,272,1241420400"; 
   d="scan'208";a="519917423"
From: "Eaton, Thomas G" <thomas.g.eaton@intel.com>
To: Daniel Stone <daniel@fooishbar.org>
CC: "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 29 May 2009 09:25:05 -0600
Subject: RE: [PATCH] drm: add connector and encoder types for MIPI displays
Thread-Topic: [PATCH] drm: add connector and encoder types for MIPI displays
Thread-Index: Acnf/OYZnDXeSOhQSY6aDTZ/LeaC5wAcROgw
Message-ID: <4060059527C3A74384B5C4ED9D30CB99884CF75F@rrsmsx506.amr.corp.intel.com>
References: <4060059527C3A74384B5C4ED9D30CB998833847C@rrsmsx506.amr.corp.intel.com>
 <4060059527C3A74384B5C4ED9D30CB99884CF09D@rrsmsx506.amr.corp.intel.com>
 <20090529012526.GB22818@fooishbar.org>
In-Reply-To: <20090529012526.GB22818@fooishbar.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the descriptions of encoder and connector, MIPI has different hardware for both the encoder and the connector than LVDS.  If it is unnecessary to present encoder and connector type information to userspace, then I agree that it could be simplified.  However, with the current implementation, I think it would be misleading to refer to all internal panels as having the same encoder and connector types unless they did in fact share the same hardware encoders and connectors.  

Cheers,
-Gideon 

-----Original Message-----
From: Daniel Stone [mailto:daniel@fooishbar.org] 
Sent: Thursday, May 28, 2009 6:25 PM
To: Eaton, Thomas G
Cc: dri-devel@lists.sourceforge.net; airlied@linux.ie; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: add connector and encoder types for MIPI displays

On Thu, May 28, 2009 at 12:16:23PM -0600, Eaton, Thomas G wrote:
> Added connector and encoder types for MIPI displays.
> 
> Signed-off-by: Thomas G Eaton <thomas.g.eaton@intel.com>

I wonder if this is all really necessary to present to userspace, or if
MIPI/LVDS/et al should just fall under 'internally-connected panel'?

Cheers,
Daniel
