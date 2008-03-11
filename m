Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYCKLab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYCKLab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYCKLaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:30:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17721 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYCKLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Waq7oIjOdegDEBYTREufrWhIyUzfOR0SwRZ4LYNVKa8pLF6inpopccIVMfO0ENEAqvsrYL7sLWxs7llOwviDz+4h/2zOIMSQymADEHk+Aq3tD3k4OeGJUG2xoI1Rp4OHxmiuAjnY3xmSB+QfYxTpHWo0g08zFlEcrDoe/3zBmuA=
Message-ID: <1ba2fa240803110430h5cabec18s5be16b586769dec@mail.gmail.com>
Date: Tue, 11 Mar 2008 13:30:16 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Subject: Re: Recent driver in linux kernel 2.6.25-rc2
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080311094236.GB4344@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219153910.GA4303@ics.muni.cz>
	 <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com>
	 <20080219224418.GA20926@ics.muni.cz>
	 <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
	 <20080311094236.GB4344@ics.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/11 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> On Mon, Mar 10, 2008 at 05:35:32PM -0700, Chatre, Reinette wrote:
>  > sorry for the delay - please do submit a bug at bughost.org to enable us
>  > to track this problem.
>  >
>  > The error you get is strange - the reason why the channel could not be
>  > set was because the device is not considered to be ready. Yet, from your
>  > debug log all the required steps appear to have completed successfully.
>  > Could you please add a print to the function
>  > iwl4965-base.c:iwl4965_is_ready to see what the value of priv->status
>  > is?
>
>  I don't have this problem in 2.6.25-rc3 and rc4. However, it seems that the
>  card does not associate with AP if I set iwcofnig wlan0 essid any. Is this
>  a bug or a feature? The AP does not use key and is visible.
>
It looks more like mac80211 bug but frankly I would prefer if this
'any' feature will be not supported.
It has security implications. The decision about to which AP to
associate should be left solely to user space.

Tomas
