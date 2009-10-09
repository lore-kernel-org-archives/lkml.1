Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbZJIV2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbZJIV2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761469AbZJIV17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:27:59 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:45596 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761416AbZJIV15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:27:57 -0400
Message-ID: <4ACFAAB7.4000308@msgid.tls.msk.ru>
Date: Sat, 10 Oct 2009 01:27:19 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: wrong final bzImage build (regading #14270)
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo> <4ACF9184.9040104@msgid.tls.msk.ru> <200910092202.51208.a.miskiewicz@gmail.com> <4ACFA36F.6000105@zytor.com>
In-Reply-To: <4ACFA36F.6000105@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 10/09/2009 01:02 PM, Arkadiusz Miskiewicz wrote:
>> I had exactly this problem few weeks ago with pdksh as /bin/sh (and 
>> bugreported to author of that change). As I workaround I used /bin/echo but 
>> using printf is more sane/portable.
>>
> 
> Yes, using printf is the right thing to do.
> 
> A patch would be appreciated.

Come on, it's just a one-word change (s/echo/printf/ in
scripts/Makefile.lib).

But it should go to Sam's tree first I guess, which already
has s|echo|/bin/echo| so it'll conflict.
It's easier to change it in whatever tree it will be changed
without complete patches.

/mjt
