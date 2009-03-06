Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZCFMfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZCFMfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 07:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZCFMfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 07:35:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4328 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZCFMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 07:35:36 -0500
Date: Fri, 6 Mar 2009 12:35:20 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Message-ID: <20090306123515.GG6493@sirena.org.uk>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236326010-683-3-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: ssm2602 codec: fix bug - kernel
	will crash when record and play in bf527-ezkit
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:53:27PM +0800, Bryan Wu wrote:

> set constraint only if the value is not 0, change the configuring way for sport

This changelog doesn't appear to apply to this patch - it looks like
was copied from the previous one?  This patch appears to suffer from a
similar issue where only the first format set by an application can ever
be used, though since this changes the constraints that are set by the
driver there's no possibility that applications will end up trying to
use a sample format that the hardware is not configured for.

Do we really need such a heavy handed fix here - what is the issue
that's being fixed?
