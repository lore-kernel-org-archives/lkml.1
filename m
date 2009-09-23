Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZIWIvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZIWIvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZIWIvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:51:14 -0400
Received: from bamako.nerim.net ([62.4.17.28]:60534 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZIWIvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:51:14 -0400
Date: Wed, 23 Sep 2009 10:51:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rudolf Marek <r.marek@assembler.cz>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the jdelvare-hwmon tree with Linus'
  tree
Message-ID: <20090923105115.506dc61c@hyperion.delvare>
In-Reply-To: <20090923114257.e6e101cf.sfr@canb.auug.org.au>
References: <20090923114257.e6e101cf.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 23 Sep 2009 11:42:57 +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the jdelvare-hwmon tree got a conflict in
> drivers/hwmon/coretemp.c between commit
> 0bf41d9f414a5cf558aff234a0ff486257537574 ("drivers/hwmon/coretemp.c:
> enable the Intel Atom") from Linus' tree and commit
> af663ff4d88e09c4e45661251e3c1eeff147ffc1 ("hwmon: (coretemp) Add support
> for Atom CPUs") from the jdelvare-hwmon tree.
> 
> I used the version from the jdelvare-hwmon for today.

Thanks for the heads up. Apparently someone managed to sneak in broken
Atom support into coretemp, while I have a working version in my hwmon
tree, which I intend to push to Linus today. I'll rebase my patch on
upstream so that it applies again, and I'll send it quickly.

-- 
Jean Delvare
