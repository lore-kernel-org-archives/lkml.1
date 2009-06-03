Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZFCOs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZFCOs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZFCOsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:48:17 -0400
Received: from smtp.df.ru ([195.42.160.16]:58541 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000AbZFCOsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:48:16 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 10:48:16 EDT
Date: Wed, 3 Jun 2009 18:28:01 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: devpts mounts too slowly
Message-ID: <20090603142801.GC21646@beaver.vrungel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

In comparison with bind/proc mounting it takes a lot more time mounting
devpts. Is it possible to somehow accelerate the process? Now there are
about 5k devpts mounting, it already took 20 minutes, further will take
even more time.

# time mount -n -i -t devpts none /home/staff/.server-1/dev/pts
real    0m0.295s
user    0m0.000s
sys     0m0.288s

# time mount -i -n --bind /var/bin /home/staff/.server-1/bin
real    0m0.004s
user    0m0.000s
sys     0m0.004s

-- 
BRGDS. Alexey Vlasov.
