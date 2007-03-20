Return-Path: <linux-kernel-owner+w=401wt.eu-S965338AbXCTQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbXCTQ7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXCTQ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:59:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965338AbXCTQ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:59:54 -0400
Date: Tue, 20 Mar 2007 12:57:36 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070320165736.GA19781@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6> <p73y7lu5yt6.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73y7lu5yt6.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 04:57:57PM +0100, Andi Kleen wrote:
 > "Robert P. J. Day" <rpjday@mindspring.com> writes:
 > 
 > > Delete the allegedly obsolete raw driver feature, which has been
 > > marked for death since 2005.
 > 
 > I think it would be better to replace it with a wrapper
 > that forces O_DIRECT and opens the underlying block device.  I suspect 
 > just dropping it will break many people's database setups, which is not
 > nice.  Widely used admin interfaces should be only broken when 
 > there is a very good reason and just "there is a better way now" 
 > doesn't seem quite strong enough.

Agreed.  Given how this keeps coming up every few months, lets just
remove that from the list..  It's not that a 306 line driver is
particularly invasive anyways..

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0bc8b0b..6b845f3 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -21,14 +21,6 @@ Who:	Pavel Machek <pavel@suse.cz>
 
 ---------------------------
 
-What:	RAW driver (CONFIG_RAW_DRIVER)
-When:	December 2005
-Why:	declared obsolete since kernel 2.6.3
-	O_DIRECT can be used instead
-Who:	Adrian Bunk <bunk@stusta.de>
-
----------------------------
-
 What:	raw1394: requests of type RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN
 When:	June 2007
 Why:	Deprecated in favour of the more efficient and robust rawiso interface.


-- 
http://www.codemonkey.org.uk
