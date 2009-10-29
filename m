Return-Path: <linux-kernel-owner+w=401wt.eu-S1751645AbZJ2Hvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbZJ2Hvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZJ2Hvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:51:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZJ2Hvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:51:49 -0400
Message-ID: <4AE949A5.9080509@np.css.fujitsu.com>
Date: Thu, 29 Oct 2009 16:52:05 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Lon Hohberger <lhh@redhat.com>, Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH] [RFC][Patch x86-tip] add notifier before kdump
References: <4AE6B1CC.6040603@np.css.fujitsu.com> <20091027150725.GD10513@redhat.com>
In-Reply-To: <20091027150725.GD10513@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek

Vivek Goyal wrote:
> - Other thing, I think Eric Biederman suggested was that we need to see
>   the code that will be executed after crash so that it can be audited and
>   keep it in kernel instead of blindly exporting a hook to module and let
>   module do whatever it want to do.
> 

I am sorry for that I could not catch the meaning of above words. In my
understanding:
    If the code is already in current kernel and no matter whether it is built
    or modulized, the code could be added before crash_kexec. Is it right?

If my understanding is not right, please let me ask a question before we
provide the code.
    What kind of code is considered as nice code and could be added into
    current kernel? Could you give me some requirements or examples
    about nice code?
    
Best regards,
Jin Dongming

> So my question is, how about introducing some infrastructure in kdump
> initrd to send a notification out?
> 
> Thanks
> Vivek

