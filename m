Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZCILVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZCILVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZCILVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:21:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1813 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZCILVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:21:33 -0400
Date: Mon, 9 Mar 2009 11:21:28 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug - kernel
	willcrash when record and play in bf527-ezkit
Message-ID: <20090309112127.GB13593@sirena.org.uk>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-2-git-send-email-cooloney@kernel.org> <20090306120145.GF6493@sirena.org.uk> <0F1B54C89D5F954D8535DB252AF412FA03AB85F5@chinexm1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA03AB85F5@chinexm1.ad.analog.com>
X-Cookie: Drilling for oil is boring.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 06:58:19PM +0800, Cai, Cliff wrote:

> This patch should be named : change the configuring way for sport,
> Because I found that the previous way is not reliable sometimes.
> Application like "tone" ,will call starup() twice before entering
> hw_params() to configure SPORT.  
> in this case SPORT won't be configured at all.

This doesn't address the concerns I raised with the patch:

> >Won't this mean that if a second data format is played the 
> >audio will be mishandled since the hardware will not have been 
> >configured for the new audio format?
