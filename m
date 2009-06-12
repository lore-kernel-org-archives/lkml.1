Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbZFLNg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbZFLNg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765390AbZFLN3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:29:50 -0400
Received: from ozlabs.org ([203.10.76.45]:55059 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765399AbZFLN3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:29:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/13] cpumask: cpu_*_map accessors and mm_cpumask()
Date: Fri, 12 Jun 2009 22:59:49 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122259.49758.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, convert the lagging archs over to using set_cpu_online etc. rather 
than frobbing the deprecated cpu_online_map et al.  (The new cpu_online_mask 
versions are const).

And get ready for variable-length cpumasks in struct mm, by using the 
mm_cpumask() accessor.

Cheers,
Rusty.
