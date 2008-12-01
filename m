Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYLAUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYLAUJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYLAUJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:09:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:51739 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYLAUJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:09:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,697,1220252400"; 
   d="scan'208";a="469955477"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Steve Moring <smoring@yahoo.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Mon, 1 Dec 2008 13:08:35 -0700
Subject: RE: [E1000-devel] Intel dg45fc motherboard still bricks with e1000e
	driver
Thread-Topic: [E1000-devel] Intel dg45fc motherboard still bricks with
 e1000e	driver
Thread-Index: AclS+BkHJwSuQTbJQgOtsSVXivrN5wA6IYPg
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365F5656C2EF@rrsmsx501.amr.corp.intel.com>
References: <452705.18074.qm@web52710.mail.re2.yahoo.com>
In-Reply-To: <452705.18074.qm@web52710.mail.re2.yahoo.com>
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

Steve Moring wrote:
> I don't know if I should enter a bug on this or not as I thought this
> one was fixed already, but I have an Intel dg45fc that comes with a
> gig enet card built in. If I force the connection to 100mb by
> connecting a switch that is only capable of 100mb, all is good, as soon > as I connect it to a gig capable switch, it bricks the machine on the > > next reboot forcing me to reload the bios.

Please file a bug so we can track this issue.

By "reload" do you mean reflash the BIOS? Can you be more specific about the symptoms?

> I have tried the following combinations: x86_64 with and without XEN,
> i586 with and without XEN, all behave identically with the above
> observations.

The NVM corruption issue that was resolved (I presume this is what you meant) was root caused to CONFIG_FTRACE being enabled in the kernel and only on ia32 arch. If you're seeing this problem on x86_64 then it is most likely unrelated.

I also presume that you are using e1000e that ships with OpenSUSE 11.1. Have you tried using the latest e1000e from sourceforge?

Thanks,
Emil
