Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZJZNqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZJZNqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZJZNqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:46:33 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:42341 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZJZNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:46:31 -0400
Subject: Re: linux-next: manual merge of the net tree with the i2c tree
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 26 Oct 2009 13:46:33 +0000
Message-Id: <1256564793.2783.3.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2009 13:46:36.0641 (UTC) FILETIME=[BCA79510:01CA5642]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.600.1016-16970.005
X-TM-AS-Result: No--18.130500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 13:37 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/sfc/sfe4001.c between commit
> 3f7c0648f727a6d5baf6117653e4001dc877b90b ("i2c: Prevent priority
> inversion on top of bus lock") from the i2c tree and commit
> c9597d4f89565b6562bd3026adbe6eac6c317f47 ("sfc: Merge sfe4001.c into
> falcon_boards.c") from the net tree.
> 
> I have applied the following merge fixup patch (after removing
> drivers/net/sfc/sfe4001.c) and can carry it as necessary.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 26 Oct 2009 12:24:55 +1100
> Subject: [PATCH] net: merge fixup for drivers/net/sfc/falcon_boards.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

