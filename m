Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYC1Tj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYC1Tj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYC1TjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:39:20 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:46463 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYC1TjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N1DGJDxPql9Dz1fhUwLJnMIXSRP1EZ5IRlOH2dDJMCQL4JGpJSxMQBYdCUGAV0hbEZHgL7VUYAPNdKQ1lGIYxstYw0P0zAvODInc5A5XQQSnQn0S4XyFAZc2Q+AnqOA5pYHRLTVN+4poKsTL9tHekSS0MKYCnlZjyG/BnufBPhM=
Message-ID: <87a5b0800803281239q43cd708ay7351c097f6368c3e@mail.gmail.com>
Date: Fri, 28 Mar 2008 19:39:17 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [Pull] Some documentation patches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <13387.1206728412@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <13387.1206728412@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 6:20 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> I've noticed that getting documentation patches merged seems to be a
>  slower and more uncertain process than it was a while back.  So I
>  figured I'd try to be one of the cool folks with their own git tree and
>  see if that works better.  Linus, if you agree, could you please pull:

A small patch for the highres timers documentation:

Signed-off-by: Will newton <will.newton@gmail.com>

---
 Documentation/hrtimers/highres.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hrtimers/highres.txt
b/Documentation/hrtimers/highres.txt
index ce0e9a9..a73ecf5 100644
--- a/Documentation/hrtimers/highres.txt
+++ b/Documentation/hrtimers/highres.txt
@@ -98,7 +98,7 @@ System-level global event devices are used for the
Linux periodic tick. Per-CPU
 event devices are used to provide local CPU functionality such as process
 accounting, profiling, and high resolution timers.

-The management layer assignes one or more of the folliwing functions to a clock
+The management layer assigns one or more of the following functions to a clock
 event device:
       - system global periodic tick (jiffies update)
       - cpu local update_process_times
-- 
1.5.4.3
