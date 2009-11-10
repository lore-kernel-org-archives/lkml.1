Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbZKJNXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbZKJNXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbZKJNW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:22:58 -0500
Received: from mail.solarflare.com ([216.237.3.220]:49948 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZKJNW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:22:56 -0500
Subject: Re: linux-next: manual merge of the net tree with the i2c tree
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>
In-Reply-To: <20091110124231.66141a0f@hyperion.delvare>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	 <20091110124231.66141a0f@hyperion.delvare>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 10 Nov 2009 13:22:58 +0000
Message-Id: <1257859379.2834.2.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 13:23:02.0304 (UTC) FILETIME=[EDD72200:01CA6208]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17000.004
X-TM-AS-Result: No--24.855300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 12:42 +0100, Jean Delvare wrote:
> Hi Stephen, Ben,
> 
> On Mon, 26 Oct 2009 13:37:57 +1100, Stephen Rothwell wrote:
> > Today's linux-next merge of the net tree got a conflict in
> > drivers/net/sfc/sfe4001.c between commit
> > 3f7c0648f727a6d5baf6117653e4001dc877b90b ("i2c: Prevent priority
> > inversion on top of bus lock") from the i2c tree and commit
> > c9597d4f89565b6562bd3026adbe6eac6c317f47 ("sfc: Merge sfe4001.c into
> > falcon_boards.c") from the net tree.
> > 
> > I have applied the following merge fixup patch (after removing
> > drivers/net/sfc/sfe4001.c) and can carry it as necessary.
> 
> I've merged the new API to get and release the i2c_adapter mutex:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=afa08974fe80c198b8650f73ed8ab59135ca10d0

Thanks, Jean.

> Ben, you can adjust your own patches to make use of this API instead of
> accessing the i2c_adapter mutex directly. That way, you are no longer
> dependent of implementation changes, and this should solve the conflict.
> 
> Stephen, you can then drop your fixup patch.

I don't think so, since the conflict resulted from joining two files
including sfe4001.c in net-next-2.6.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

