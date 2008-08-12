Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYHLD7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYHLD7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYHLD7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:59:22 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35603 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYHLD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:59:21 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/1] iwlwifi: fix printk newlines
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218504137.3107.201.camel@debian.sh.intel.com>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
	 <1218502555.25524.22.camel@californication>
	 <1218504137.3107.201.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 05:59:25 +0200
Message-Id: <1218513565.25524.31.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yi,

> > >       s = iwl4965_get_sub_band(priv, channel);
> > >       if (s >= EEPROM_TX_POWER_BANDS) {
> > > -             IWL_ERROR("Tx Power can not find channel %d ",
> > channel);
> > > +             IWL_ERROR("Tx Power can not find channel %d\n",
> > channel);
> > >               return -1;
> > >       }
> > 
> > can we not just fix IWL_ERROR to always append the newline?
> 
> We should give the users more control to the style I think.

what kind of control do you expect? If you need two lines of debug or
error output, call IWL_ERROR twice. This will also result in the
KERN_ERR is set and not forgotten since that has to follow the newline.

Regards

Marcel


