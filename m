Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYAKBZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYAKBZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYAKBZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:25:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:39394 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbYAKBY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hYhcTgZuUJ9O2POFOEV9Ge/Me/I6T2B5UCwlxyELFPsSHKN6l0UN4Dexm/02GD2FaDpbZRdFna/Baa+PkRZLn6k/snqScKDdgqfGqUOa+xOsip7g2zUz/g5F3ZrlN6tThWaJej5YclpZjbimXABq+TWMDQsrlKVB6Dt+eAUsBlA=
Message-ID: <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com>
Date: Fri, 11 Jan 2008 10:24:54 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Cc: "Zhu, Yi" <yi.zhu@intel.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
In-Reply-To: <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11998765481610-git-send-email-joonwpark81@gmail.com>
	 <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Reinette,

2008/1/11, Chatre, Reinette <reinette.chatre@intel.com>:
>
> Could synchronize_irq() be moved into iwl_disable_interrupts() ? I am

At this time, iwl_disable_interrupts() can be called with irq
disabled, so for do that I think additional modification would be
needed.

> also wondering if we cannot call tasklet_kill() before
> iwl_disable_interrupts() ... thus preventing it from being scheduled
> when we are going down.

Thanks for your catch, it seems tasklet can re-enable interrupts.
I'll handle and make an another patch for them at this weekend :)

Thanks,
Joonwoo
