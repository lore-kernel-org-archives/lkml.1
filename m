Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYKSTnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYKSTnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYKSTnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:43:31 -0500
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:48739 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbYKSTna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:43:30 -0500
Subject: Re: linux-next: Tree for November 19 (mtd build error)
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-net-drivers@solarflare.com
In-Reply-To: <1227122696.27728.625.camel@macbook.infradead.org>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
	 <20081119105321.477e618a.randy.dunlap@oracle.com>
	 <1227121104.27728.618.camel@macbook.infradead.org>
	 <492463A1.3000306@oracle.com>  <1227122287.3052.7.camel@achroite>
	 <1227122696.27728.625.camel@macbook.infradead.org>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Wed, 19 Nov 2008 19:43:25 +0000
Message-Id: <1227123805.3052.10.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 19:24 +0000, David Woodhouse wrote:
> On Wed, 2008-11-19 at 19:18 +0000, Ben Hutchings wrote:
> > So does the dependency need to be something like
> > "depends on SFC && MTD && !(SFC=y && MTD=m)"?
> 
> If it's a separate driver, perhaps it's sufficient just to make it a
> tristate and make it depend on SFC && MTD?

It's not a separate driver.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

