Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZFFDwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZFFDwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 23:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZFFDwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 23:52:10 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:9149
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZFFDwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 23:52:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYBAPqEKUp8qN0Z/2dsb2JhbAAI0GaECgU
X-IronPort-AV: E=Sophos;i="4.41,314,1241366400"; 
   d="scan'208";a="454570127"
Subject: Re: [PATCH] gpiolib: add gpio_request/free_irq
From: Ben Nizette <bn@niasdigital.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <200906051151.05779.hartleys@visionengravers.com>
References: <200906051151.05779.hartleys@visionengravers.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 13:51:25 +1000
Message-Id: <1244260285.22690.25.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 11:51 -0700, H Hartley Sweeten wrote:
> Add support functions to gpiolib to request/free gpio irqs.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Can this really not just be open-coded?  I see other subsystems wrap up
request_irq but that tends to be in cases where there's a lot of
boilerplate to go through or it closes a race or something.  Maybe
there's just insufficient changelogging - why do we want this?

Thanks,
	--Ben.



