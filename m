Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYLCVqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYLCVqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYLCVpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:45:53 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:57146 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYLCVpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:45:53 -0500
Subject: Re: [patch 2.6.28-rc7] regulator: init/link earlier
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200812012150.13909.david-b@pacbell.net>
References: <200812011335.43551.david-b@pacbell.net>
	 <20081201225312.GA6699@sirena.org.uk>
	 <200812012150.13909.david-b@pacbell.net>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 21:45:49 +0000
Message-Id: <1228340749.6529.76.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 21:50 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Move regulator earlier in link sequence.
> 
> The regulator core currently initializes as a core_initcall() to be
> available early ... but then it links way late, throwing away that
> benefit, so regulators available at e.g. subsys_initcall() are not
> available to subsystems which need to use them.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Applied.

Thanks

Liam

