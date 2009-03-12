Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZCLNPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZCLNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZCLNPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:15:22 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:22249 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZCLNPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:15:20 -0400
From: "Seger, Mark" <mark.seger@hp.com>
To: "util-linux-ng@vger.kernel.org" <util-linux-ng@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Thu, 12 Mar 2009 13:14:15 +0000
Subject: New release of collectl now supports NFS V4 and buddyinfo
Thread-Topic: New release of collectl now supports NFS V4 and buddyinfo
Thread-Index: AcmjFHF3Va8IFjbmTcCGwmkZycgzXw==
Message-ID: <9FCE3A46FE7C8045A6207AE4B42E9F9A4792FDA420@GVW1119EXC.americas.hpqcorp.net>
References: <477FDAA8.2030001@hp.com>
In-Reply-To: <477FDAA8.2030001@hp.com>
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

Just a quick note on this.  If you've been staying away from collectl because it didn't support V4 of nfs, I finally got around to adding it.  One thing that's kind of cool is if you run the command "collectl -sF --home", you'll see a top-like command that displays most of the nfs stats on all types of the systems' nfs client/servers for versions 2,3 and 4.  You can read a little more about it at: http://collectl.sourceforge.net/NfsInfo.html

While I was at it I also added buddyinfo monitoring, so you can literally watch your fragment distribution change in real-time using the command "collectl -sB --home" as described here - http://collectl.sourceforge.net/BuddyInfo.html.  I'm still not sure how one can make the most out of this information or if I'm displaying it in the most useful manner, but as always all feedback is welcome, preferably on the collectl mailing list collectl-interest@lists.sourceforge.net.

-mark


 

