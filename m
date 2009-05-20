Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZETVjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZETVjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZETVjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:39:33 -0400
Received: from quechua.inka.de ([193.197.184.2]:43922 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZETVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:39:33 -0400
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 17:39:32 EDT
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] Apply the PG_sensitive flag to audit subsystem
References: <20090520185005.GC10756@oblivion.subreption.com>
Organization: private Linux site, southern Germany
From: Olaf Titz <olaf@bigred.inka.de>
Date: Wed, 20 May 2009 23:15:46 +0200
Message-ID: <E1M6t8c-0006OZ-A7@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (!(gfp_mask & GFP_SENSITIVE))
> +		gfp_mask |= GFP_SENSITIVE;
> +

The condition is unnecessary. Just do the |= in all cases.

Olaf
