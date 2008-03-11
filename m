Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYCKJnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYCKJnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYCKJnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:43:10 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37613 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYCKJnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:43:09 -0400
Date: Tue, 11 Mar 2008 10:42:36 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Recent driver in linux kernel 2.6.25-rc2
Message-ID: <20080311094236.GB4344@ics.muni.cz>
References: <20080219153910.GA4303@ics.muni.cz> <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com> <20080219224418.GA20926@ics.muni.cz> <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 217.77.165.56
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 11 Mar 2008 10:42:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 05:35:32PM -0700, Chatre, Reinette wrote:
> sorry for the delay - please do submit a bug at bughost.org to enable us
> to track this problem.
> 
> The error you get is strange - the reason why the channel could not be
> set was because the device is not considered to be ready. Yet, from your
> debug log all the required steps appear to have completed successfully.
> Could you please add a print to the function
> iwl4965-base.c:iwl4965_is_ready to see what the value of priv->status
> is?

I don't have this problem in 2.6.25-rc3 and rc4. However, it seems that the
card does not associate with AP if I set iwcofnig wlan0 essid any. Is this 
a bug or a feature? The AP does not use key and is visible.

-- 
Luká¹ Hejtmánek
