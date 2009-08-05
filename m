Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZHEW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZHEW3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZHEW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:29:24 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:33996 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZHEW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:29:24 -0400
Date: Thu, 6 Aug 2009 00:29:20 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       spyro@f2s.com, cbou@mail.ru, mreimer@vpop.net
Subject: Re: [PATCH 2/5] pda-power: switch to new dev_pm_ops
Message-ID: <20090805222920.GF19257@buzzloop.caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de> <1249496971-9019-1-git-send-email-daniel@caiaq.de> <1249496971-9019-2-git-send-email-daniel@caiaq.de> <200908052149.55567.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908052149.55567.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 09:49:52PM +0200, Frans Pop wrote:
> Daniel Mack wrote:
> > +static struct dev_pm_ops pda_power_pm_ops = {
> > +       .suspend        = pda_power_suspend,
> > +       .freeze         = pda_power_freeze,
> 
> Hmmm. Where's pda_power_freeze defined? Forgot to (compile)test the 
> patches?

Yes, sorry. I can't test hibernation, so I didn't pay enough attention.
I'll resend them anyway with Rafael's new macro used.

Thanks,
Daniel
