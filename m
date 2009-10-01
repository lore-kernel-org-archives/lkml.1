Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZJAOzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZJAOzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZJAOzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:55:13 -0400
Received: from ru.mvista.com ([213.79.90.228]:15146 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752740AbZJAOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:54:59 -0400
Date: Thu, 1 Oct 2009 18:55:00 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] power_supply: Factor out WM831x backup battery
 charger
Message-ID: <20091001145500.GA21973@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 03:41:06PM +0100, Mark Brown wrote:
> The backup battery on WM831x is a separate IP block to the main PMU and
> is largely unrelated to the main supply functionality. Factor it out into
> a separate driver in order to reflect this and better support future
> hardware versions.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>

Looks good. Should I apply it, or it depends on 1/4 and 2/4?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
