Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZHLVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZHLVAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZHLVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:00:05 -0400
Received: from main.gmane.org ([80.91.229.2]:47928 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZHLVAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:00:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Barkowski <michaelbarkowski@ruggedcom.com>
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
Date: Wed, 12 Aug 2009 16:45:55 -0400
Message-ID: <4A832A03.6020507@ruggedcom.com>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru> <20090731004100.GB8371@oksana.dev.rtsoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 24.114.226.27
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
In-Reply-To: <20090731004100.GB8371@oksana.dev.rtsoft.ru>
Cc: linux-mtd@lists.infradead.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anton,

Is m25p_probe now valid with dev.platform_data == NULL, for of platforms?

Then shouldn't you have the following change as well, near the end of
the function?

-  	} else if (data->nr_parts)
+  	} else if (data && data->nr_parts)
		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
				data->nr_parts, data->name);

Or am I misunderstanding something?

-- 
Michael Barkowski
RuggedCom

