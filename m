Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbXGVFPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbXGVFPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXGVFOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:14:55 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:11119 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbXGVFOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KdXkIdMY64oCuIdFSveY/WhH888RDGM8CeSkTlsxLaTHCUIYbWLdv2GnbtHKR5H6kAoHkzgHdu0PV1jxU4m+A0F2IpFKuNRkpKNIhqgMeecOhNB6wfL+otvk018wQvvFHKzK7ljEzEeu3R6d6mbGOyRa4Zxv3QSVHvOukGd0FsQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [00/37] Clean up duplicate includes (resend patch 28)
Date: Sun, 22 Jul 2007 07:13:56 +0200
User-Agent: KMail/1.9.7
References: <200707211701.23911.jesper.juhl@gmail.com> <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
In-Reply-To: <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220713.56098.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 04:30:41 you wrote:
> On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > [...]
> > These are the patches in this series :
> 
> Ok, I've reviewed all patches in this series except:
> 
> >  [PATCH][12/37] Clean up duplicate includes in drivers/net/
> >  [PATCH][28/37] Clean up duplicate includes in net/ipv4/
> >  [PATCH][32/37] Clean up duplicate includes in net/sunrpc/
> 
Here's patch 28 again.

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c9e2b5e..0f1d7be 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -75,7 +75,6 @@
 #include <net/icmp.h>
 #include <net/checksum.h>
 #include <net/inetpeer.h>
-#include <net/checksum.h>
 #include <linux/igmp.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
diff --git a/net/ipv4/ipvs/ip_vs_ctl.c b/net/ipv4/ipvs/ip_vs_ctl.c
index e1052bc..c32781d 100644
--- a/net/ipv4/ipvs/ip_vs_ctl.c
+++ b/net/ipv4/ipvs/ip_vs_ctl.c
@@ -29,7 +29,6 @@
 #include <linux/proc_fs.h>
 #include <linux/workqueue.h>
 #include <linux/swap.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 #include <linux/netfilter.h>
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index dcc12b1..69bd362 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -19,7 +19,6 @@
 #include <linux/udp.h>
 #include <linux/icmp.h>
 #include <linux/if_arp.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/x_tables.h>


