Return-Path: <linux-kernel-owner+w=401wt.eu-S965237AbXBOIWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965237AbXBOIWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 03:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965238AbXBOIWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 03:22:02 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43144 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965237AbXBOIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 03:22:00 -0500
Message-ID: <45D418DC.5040605@bull.net>
Date: Thu, 15 Feb 2007 09:25:00 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>	<20070116063030.761795000@bull.net>	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>	<m1mz3poeda.fsf@ebiederm.dsl.xmission.com> <45CC68BA.4010403@bull.net>	<m11wkz5gd2.fsf@ebiederm.dsl.xmission.com> <45D17F8D.3020207@bull.net>	<m14ppqtlk3.fsf@ebiederm.dsl.xmission.com> <45D406BF.2060009@bull.net> <m1d54bn9lo.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d54bn9lo.fsf@ebiederm.dsl.xmission.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/02/2007 09:23:10,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/02/2007 09:23:16,
	Serialize complete at 15/02/2007 09:23:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nadia Derbey <Nadia.Derbey@bull.net> writes:
> 
> 
>>But, what do you do with Oracle that's asking maxfiles to be set to 0x10000,
>>while the default value might be enough for a system that's not running Oracle.
>>I'm afraid that giving boot time values to the max_* tunables we will loose all
>>the benefits from /proc (or /sys): it is impossible to anticipate what an OS
>>will be used for. So allowing such things to be changed without having to reboot
>>the machine is in my mind quite a powerful feature we should keep taking
>>adavntage of.
> 
> 
> I'm not saying remove user spaces' ability to set the
> denial-of-service limits.  I'm saying if they need to be frequently
> changed we need to update the default so they are higher by default.
> 
> There really is no cost in moving those values up and down  it is just
> an arbitrary integer used in comparisons.  But if we can make a good
> guess that still catches runaway programs before they kill the machine
> but also allows more programs to work out of the box we are in better
> shape.
> 
OK, happy to see we are on the same wavelength (and sorry for 
misunderstanding what you were saying ;-) )

Regards,
Nadia
