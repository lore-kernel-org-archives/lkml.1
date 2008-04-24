Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYDXM7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYDXM7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYDXM7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:59:36 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3876 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYDXM7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:59:35 -0400
Date: Thu, 24 Apr 2008 08:16:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>, Roel Kluin <12o3l@tiscali.nl>,
       linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: rndis_wlan: modparam_workaround_interval is
	never below 0.
Message-ID: <20080424121613.GA3879@tuxdriver.com>
References: <480F97B5.9030009@tiscali.nl> <1209027451.3357.49.camel@johannes.berg> <20080424122628.zioaht24o4ko4ww8@naisho.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424122628.zioaht24o4ko4ww8@naisho.dyndns.info>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 12:26:28PM +0300, Jussi Kivilinna wrote:
> Quoting Johannes Berg <johannes@sipsolutions.net>:
>
>>
>> Eh, why not make the modparam unsigned and default to 500?
>>
>> johannes
>>
>
> Now that I stop and think about it, that would be better option. The 
> modparam already has default value of 500.
>
> Reason why workaround modparam is signed, is that value -1 did have some 
> functionality in some early version. That then changed and 
> priv->param_workaround_interval changed to unsigned and forgot about 
> modparam.

I merged the patch, so if you want that behavior we need a new patch.

John
-- 
John W. Linville
linville@tuxdriver.com
