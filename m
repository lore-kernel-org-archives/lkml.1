Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZCKO3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZCKO3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZCKO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:29:44 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60413 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbZCKO3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:29:42 -0400
Subject: Re: [PATCH 2/2] regulator: Don't warn on omitted voltage
 constraints
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1236702516-30733-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1236702516-30733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1236702516-30733-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 14:29:39 +0000
Message-Id: <1236781779.6781.154.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 16:28 +0000, Mark Brown wrote:
> Specifying voltage constraints is optional (and only needed if the
> consumer is allowed to change the voltage) so don't complain unless
> a voltage has been specified.
> 
> Also avoid surprises with a dangling else while we're here.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)

Applied.

Thanks

Liam

