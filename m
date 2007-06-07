Return-Path: <linux-kernel-owner+w=401wt.eu-S966613AbXFGWKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966613AbXFGWKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966608AbXFGWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:09:39 -0400
Received: from xenotime.net ([66.160.160.81]:59428 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966243AbXFGWJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:09:37 -0400
Date: Thu, 7 Jun 2007 15:10:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 9/36] drivers edac new intel 5000X mc driver
Message-Id: <20070607151012.e4145965.rdunlap@xenotime.net>
In-Reply-To: <20070607143840.d259a4c1.akpm@linux-foundation.org>
References: <404349.85191.qm@web50103.mail.re2.yahoo.com>
	<20070607143840.d259a4c1.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 14:38:40 -0700 Andrew Morton wrote:

> On Sun, 3 Jun 2007 07:40:26 -0700 (PDT)
> Doug Thompson <norsk5@yahoo.com> wrote:
> 
> > +static void i5000_process_nonfatal_error_info(struct mem_ctl_info
> > *mci,
> > +					      struct i5000_error_info * info,
> 
> ditto (please check whole patch)
> 
> (I thought checkpatch.pl would catch this, but it doesn't?)

Here's a small patch against v.3 that will catch this.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Catch "struct * blah" by allowing spaces preceding the '*'.
Bah.  Maybe the error string needs a small change also.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- scripts.orig/checkpatch-v3.pl
+++ scripts/checkpatch-v3.pl
@@ -393,7 +393,7 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
+		if ($line=~/[\sA-Za-z\d_]+\* [A-Za-z\d_]+/) {
 			print "\"foo* bar\" should be \"foo *bar\"\n";
 			print "$herecurr";
 			$clean = 0;
