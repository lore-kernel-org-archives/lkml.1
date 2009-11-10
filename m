Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZKJPK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZKJPK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbZKJPK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:10:26 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:54132 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbZKJPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:10:25 -0500
Subject: Re: linux-next: manual merge of the net tree with the i2c tree
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>
In-Reply-To: <20091110160246.506b7789@hyperion.delvare>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	 <20091110124231.66141a0f@hyperion.delvare>
	 <1257859379.2834.2.camel@achroite.uk.solarflarecom.com>
	 <20091110160246.506b7789@hyperion.delvare>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 10 Nov 2009 15:10:27 +0000
Message-Id: <1257865827.2834.12.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 15:10:31.0131 (UTC) FILETIME=[F1A40AB0:01CA6217]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17000.004
X-TM-AS-Result: No--20.620200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 16:02 +0100, Jean Delvare wrote:
> On Tue, 10 Nov 2009 13:22:58 +0000, Ben Hutchings wrote:
> > On Tue, 2009-11-10 at 12:42 +0100, Jean Delvare wrote:
> > > Ben, you can adjust your own patches to make use of this API instead of
> > > accessing the i2c_adapter mutex directly. That way, you are no longer
> > > dependent of implementation changes, and this should solve the conflict.
> > > 
> > > Stephen, you can then drop your fixup patch.
> > 
> > I don't think so, since the conflict resulted from joining two files
> > including sfe4001.c in net-next-2.6.
> 
> My patch series no longer touches sfe4001.c, so how would the conflict
> remain?

Because your patch to introduce i2c_{lock,unlock}_adapter() are not in
net-next-2.6 yet.

David, you might want to pull from Linus and resolve this, giving
Stephen a break.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

