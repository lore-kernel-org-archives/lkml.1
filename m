Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYD1Mh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYD1Mh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763457AbYD1Mht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:37:49 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:64186 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762992AbYD1Mhs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:37:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIgANphFUhMROPA/2dsb2JhbAABgVKoSg
Date: Mon, 28 Apr 2008 08:37:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 27/37] From: Adrian Bunk <bunk@kernel.org>
Message-ID: <20080428123742.GA4821@Krystal>
References: <20080424150324.802695381@polymtl.ca> <20080424151404.283234087@polymtl.ca> <20080428095403.GG16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080428095403.GG16379@cs181133002.pp.htv.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:36:46 up 59 days,  8:47,  3 users,  load average: 0.97, 0.95,
	0.75
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> Something went wrong with the Subject.
> 

Yes, the patch should look like this. Thanks!

Mathieu


make marker_debug static

With the needlessly global marker_debug being static gcc can optimize the
unused code away.

From: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/marker.c~make-marker_debug-static kernel/marker.c
--- a/kernel/marker.c~make-marker_debug-static
+++ a/kernel/marker.c
@@ -28,7 +28,7 @@ extern struct marker __start___markers[]
 extern struct marker __stop___markers[];
 
 /* Set to 1 to enable marker debug output */
-const int marker_debug;
+static const int marker_debug;
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
_

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
