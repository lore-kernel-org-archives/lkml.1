Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbZKRNlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbZKRNlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZKRNlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:41:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36860 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691AbZKRNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:41:08 -0500
Date: Wed, 18 Nov 2009 13:41:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Subject: Re: Null suspend/resume functions
Message-ID: <20091118134112.GF6592@rakim.wolfsonmicro.main>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
 <aec7e5c30911170446n71031671i48aca11f5276405d@mail.gmail.com>
 <20091117125901.GF823@rakim.wolfsonmicro.main>
 <200911172314.04396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911172314.04396.rjw@sisk.pl>
X-Cookie: May explode if improperly recharged.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:14:04PM +0100, Rafael J. Wysocki wrote:

> In fact, it's not mandatory for bus types, not for drivers.  IMO bus types
> really have to know how to suspend a device and how to resume it,
> otherwise the core framework won't be useful anyway.  What the bus type does
> about drivers not implementing ->runtime_suspend() or ->runtime_resume(), it's
> up to the bus type.  That's even documented IIRC.

OK, thanks - I hadn't realised that these were being called directly
from the bus type code rather than by the core.
