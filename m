Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbYIENLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbYIENLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYIENKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:10:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4105 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYIENKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:10:53 -0400
Date: Fri, 5 Sep 2008 14:10:50 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/9] ASoC: Blackfin: SPORT peripheral interface driver
Message-ID: <20080905131049.GH12383@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org> <1220610102-7716-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220610102-7716-3-git-send-email-cooloney@kernel.org>
X-Cookie: Universe, n.:
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 06:21:35PM +0800, Bryan Wu wrote:

> +	/* Maybe the dummy buffer descriptor ring is damaged */
> +	sport->dummy_rx_desc->next_desc_addr = \
> +			(unsigned long)(sport->dummy_rx_desc+1);

Here and elsewhere in this driver you've got continuation characters
which aren't need.  I've fixed this up locally (and some additional
checkpatch/coding standards things) here and in other patches in the
series.

Otherwise the patch series looks good to go, thanks - I'm just about to
review the codec driver patch that it depends upon.
