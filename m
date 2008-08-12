Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYHLBXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYHLBXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYHLBXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:23:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:60777 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbYHLBXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:23:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="32586118"
Subject: Re: [ipw3945-devel] [PATCH 1/1] iwlwifi: fix printk newlines
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218502555.25524.22.camel@californication>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
	 <1218502555.25524.22.camel@californication>
Content-Type: text/plain
Organization: Intel Corp.
Date: Tue, 12 Aug 2008 09:22:17 +0800
Message-Id: <1218504137.3107.201.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 02:55 +0200, Marcel Holtmann wrote:
> >       s = iwl4965_get_sub_band(priv, channel);
> >       if (s >= EEPROM_TX_POWER_BANDS) {
> > -             IWL_ERROR("Tx Power can not find channel %d ",
> channel);
> > +             IWL_ERROR("Tx Power can not find channel %d\n",
> channel);
> >               return -1;
> >       }
> 
> can we not just fix IWL_ERROR to always append the newline?

We should give the users more control to the style I think.

Thanks,
-yi

