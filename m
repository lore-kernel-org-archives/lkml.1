Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZFSJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZFSJgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZFSJfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:35:54 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38371 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZFSJfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:35:53 -0400
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Barry Song <21cnbao@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 10:35:50 +0100
Message-Id: <1245404150.21421.272.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 17:28 +0800, Barry Song wrote:
> 1. add AD1938 codec driver                   (codec)
> 2. add blackfin SPORT-TDM DAI and PCM driver (platform)
> 3. add bf5xx board with AD1938 driver        (machine)
> Signed-off-by: Barry Song <21cnbao@gmail.com>
> ---
>  include/sound/soc-dai.h            |    1 +
>  sound/soc/blackfin/Kconfig         |   46 +++-
>  sound/soc/blackfin/Makefile        |    6 +
>  sound/soc/blackfin/bf5xx-ad1938.c  |  178 ++++++++++++
>  sound/soc/blackfin/bf5xx-tdm-pcm.c |  330 ++++++++++++++++++++++
>  sound/soc/blackfin/bf5xx-tdm-pcm.h |   21 ++
>  sound/soc/blackfin/bf5xx-tdm.c     |  295 +++++++++++++++++++
>  sound/soc/blackfin/bf5xx-tdm.h     |   14 +
>  sound/soc/codecs/Kconfig           |    4 +
>  sound/soc/codecs/Makefile          |    2 +
>  sound/soc/codecs/ad1938.c          |  548 ++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/ad1938.h          |   68 +++++
>  12 files changed, 1512 insertions(+), 1 deletions(-)
>  create mode 100644 sound/soc/blackfin/bf5xx-ad1938.c
>  create mode 100644 sound/soc/blackfin/bf5xx-tdm-pcm.c
>  create mode 100644 sound/soc/blackfin/bf5xx-tdm-pcm.h
>  create mode 100644 sound/soc/blackfin/bf5xx-tdm.c
>  create mode 100644 sound/soc/blackfin/bf5xx-tdm.h
>  create mode 100644 sound/soc/codecs/ad1938.c
>  create mode 100644 sound/soc/codecs/ad1938.h
> 

Could you break this patch into smaller chunks. This should make it
easier to review and apply.

Thanks

Liam 


