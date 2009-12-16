Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZLPGq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZLPGq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZLPGqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:46:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59017 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZLPGqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:46:23 -0500
Message-ID: <4B288232.4060901@canonical.com>
Date: Wed, 16 Dec 2009 14:46:10 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: reinette chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com> <1260848710-5650-1-git-send-email-ike.pan@canonical.com> <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com> <20091215134943.GA11667@kroah.com> <20091215163100.GC8097@tuxdriver.com> <1260906168.9623.4.camel@rc-desk> <20091215194938.GA13297@kroah.com>
In-Reply-To: <20091215194938.GA13297@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Dec 15, 2009 at 11:42:48AM -0800, reinette chatre wrote:
>> On Tue, 2009-12-15 at 08:31 -0800, John W. Linville wrote:
>>> On Tue, Dec 15, 2009 at 05:49:43AM -0800, Greg KH wrote:
>>>> On Tue, Dec 15, 2009 at 03:02:17PM +0800, Ike Panhc wrote:
>>>>> Please consider applying to linux-2.6.31.y
>>>> I need the subsystem maintainer to agree with this, have they?
>>> It seems fine to me.  You may want to let Intel comment too.
>>>
>> No objection here. Even so, I find it strange that this patch fixes a
>> problem since it really should not have any functional changes. 
> 
> Ok, if there is no functional change, why is this needed?
> 
> Ike?
> 
> thanks,
> 
> greg k-h
I review the patch again. Yes, it is no functional change. Sorry I have
misunderstanding about the patch. Please do not put the second patch into
stable.

But Please consider applying the first patch (change IWL6000_UCODE_API_MAX
to v4) to 2.6.31-stable tree. It will be good to use v4 firmware on iwl6000.
