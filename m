Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZKJPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZKJPCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbZKJPCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:02:44 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61862 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZKJPCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:02:43 -0500
Date: Tue, 10 Nov 2009 16:02:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>
Subject: Re: linux-next: manual merge of the net tree with the i2c tree
Message-ID: <20091110160246.506b7789@hyperion.delvare>
In-Reply-To: <1257859379.2834.2.camel@achroite.uk.solarflarecom.com>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	<20091110124231.66141a0f@hyperion.delvare>
	<1257859379.2834.2.camel@achroite.uk.solarflarecom.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 13:22:58 +0000, Ben Hutchings wrote:
> On Tue, 2009-11-10 at 12:42 +0100, Jean Delvare wrote:
> > Ben, you can adjust your own patches to make use of this API instead of
> > accessing the i2c_adapter mutex directly. That way, you are no longer
> > dependent of implementation changes, and this should solve the conflict.
> > 
> > Stephen, you can then drop your fixup patch.
> 
> I don't think so, since the conflict resulted from joining two files
> including sfe4001.c in net-next-2.6.

My patch series no longer touches sfe4001.c, so how would the conflict
remain?

-- 
Jean Delvare
