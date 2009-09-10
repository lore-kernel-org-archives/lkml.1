Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZIJSuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZIJSuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZIJSuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:50:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:59155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZIJSuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,365,1249282800"; 
   d="scan'208";a="725794477"
Subject: Re: iwlagn: order 2 page allocation failures
From: reinette chatre <reinette.chatre@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Mel Gorman <mel@csn.ul.ie>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <200909102043.17883.elendil@planet.nl>
References: <200909060941.01810.elendil@planet.nl>
	 <20090910090206.GA22276@csn.ul.ie> <1252606547.30150.304.camel@rc-desk>
	 <200909102043.17883.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 11:50:24 -0700
Message-Id: <1252608624.30150.312.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 11:43 -0700, Frans Pop wrote:

> Looks good to me (from a user's perspective).

Thank you very much for looking at it.

> IIUC the first message is now only displayed if IWL debugging is 
> explicitly enabled, 

Correct. User will have to enable debug flag of 0x1.

> It seems to me that, with debugging enabled, the "Failed to allocate SKB 
> buffer." message may get repeated, but I guess that's minor.

Yes, it will be repeated. I did add a "net_ratelimit()" to it so it
should not be too overwhelming. I did not care to limit it even more
since we are now talking about a debug message as opposed to an error
message on the console.


> One nitpick. As you've made the message into sentences, "Only %u free 
> buffers remaining" should IMO also end with a period.

Sorry - will fix. I will not post a new version to this thread for this
issue, but it will be fixed in the next version I send out.

Reinette


