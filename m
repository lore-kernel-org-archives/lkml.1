Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZLONlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZLONlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZLONlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:41:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47258 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZLONlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:41:11 -0500
Date: Tue, 15 Dec 2009 13:41:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix unbalanced disables/enables in
	regulator_bulk_{enable,disable} error path
Message-ID: <20091215134105.GA11022@sirena.org.uk>
References: <1260883801-22667-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260883801-22667-1-git-send-email-lars@metafoo.de>
X-Cookie: With your bare hands?!?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 02:30:01PM +0100, Lars-Peter Clausen wrote:
> Currently it is possible for regulator_bulk_{enable,disable} operations to
> generate unbalanced regulator_{disable,enable} calls in its error path.
> In case of an error only those regulators of the bulk operation which actually
> had been enabled/disabled should get their original state restored.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
