Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZFEMZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZFEMZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZFEMZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:25:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54109 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZFEMZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:25:02 -0400
Date: Fri, 5 Jun 2009 14:24:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Subject: Re: [PATCH 06/10] mac802154: add a software MAC 802.15.4
	implementation
Message-ID: <20090605122456.GA1717@ucw.cz>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-2-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-5-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-01 18:54:47, Dmitry Eremin-Solenikov wrote:
> Some of available devices are just dump radios implementing IEEE 802.15.4
> PHY layer. This commit adds a common library that acts like an intermediate
> layer between our socket family and drivers for those dumb devices.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Sergey Lapin <slapin@ossfans.org>
> ---
>  include/net/ieee802154/mac802154.h |   79 ++++

Could we get some name that is not alphabet soup? Is 'zigbee'
trademarked so heavily that it can't be used? Maybe 'wpan'?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
