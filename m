Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZCRXyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZCRXyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 19:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZCRXxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 19:53:48 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:40209 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752128AbZCRXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 19:53:47 -0400
Message-ID: <49C18987.5000009@snapgear.com>
Date: Thu, 19 Mar 2009 09:53:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
References: <200903120437.03837.rob@landley.net> <200903172304.00157.rob@landley.net> <49C087F3.3080507@snapgear.com> <200903181312.02047.rob@landley.net>
In-Reply-To: <200903181312.02047.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Rob Landley wrote:
> On Wednesday 18 March 2009 00:34:43 Greg Ungerer wrote:
>> Hi Rob,
>>
>> Rob Landley wrote:
>>> On Monday 16 March 2009 18:10:45 Greg Ungerer wrote:
>>>>>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>>>>>> fix-includes
> ...
>>> What _should_ I have done?
>> The git clone you have done will just get the master branch,
>> and put it in a directory named fix-includes.
>>
>> Which is ok, but you still won't have the "fix-includes" branch.
>> Do this after the clone:
>>
>>    git pull
>> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>> fix-includes
> 
> Ah, that did something interesting...  And the resulting headers built in 
> uClibc.  (Works for me!)
> 
> confirmed-uClibc-builds-with-it-by: Rob Landley <rob@landley.net>

Thats great, thanks.
I'll push to Linus then.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
