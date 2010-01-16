Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0APBwP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 20:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328Ab0APBwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 20:52:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1236 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab0APBwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 20:52:12 -0500
Subject: [PATCH] scripts/get_maintainer.pl: Change --sections to print in
 the same style as MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B510EFE.50201@s5r6.in-berlin.de>
References: <1263408063.8011.116.camel@Joe-Laptop.home>
	 <20100114151254.72b57501.akpm@linux-foundation.org>
	 <1263519770.1903.49.camel@Joe-Laptop.home>
	 <4B507B73.6000404@s5r6.in-berlin.de>
	 <1263602598.15135.30.camel@Joe-Laptop.home>
	 <4B510EFE.50201@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 17:52:10 -0800
Message-ID: <1263606730.15135.46.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 01:57 +0100, Stefan Richter wrote:
> > The MAINTAINERS file uses tab or space after "^[A-Z]:"
> > Perhaps that format should be kept.
> Right, the original format is actually better (if you want to tweak your
> output at all).

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 4cd2b4c..8461452 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -381,8 +381,10 @@ foreach my $file (@files) {
 		    $line =~ s/\\\./\./g;       	##Convert \. to .
 		    $line =~ s/\.\*/\*/g;       	##Convert .* to *
 		}
+		$line =~ s/^([A-Z]):/$1:\t/g;
 		print("$line\n");
 	    }
+	    print("\n");
 	}
     }
 



