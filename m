Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbZCILzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbZCILzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZCILzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:55:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2614 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZCILzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:55:21 -0400
Date: Mon, 9 Mar 2009 11:55:16 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: ssm2602 codec: fix bug -
	kernelwill crash when record and play in bf527-ezkit
Message-ID: <20090309115516.GC13593@sirena.org.uk>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-3-git-send-email-cooloney@kernel.org> <20090306123515.GG6493@sirena.org.uk> <0F1B54C89D5F954D8535DB252AF412FA03AB85FE@chinexm1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA03AB85FE@chinexm1.ad.analog.com>
X-Cookie: Drilling for oil is boring.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 07:07:26PM +0800, Cai, Cliff wrote:

>  This patch should be named :set constraint only if the value is not 0.
>  I found that sometimes substream may be not NULL,but runtime can be
> NULL,So the previous way will cause
> Kernel to crash.

Again, this doesn't address the concern about the fact that you're only
supporting one time configuration here.
