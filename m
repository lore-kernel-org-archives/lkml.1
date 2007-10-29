Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXJ2KN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXJ2KN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXJ2KNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:13:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:3551 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbXJ2KNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:13:50 -0400
Message-ID: <4725B256.3020807@fr.ibm.com>
Date: Mon, 29 Oct 2007 11:13:42 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Adrian Bunk <bunk@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Kir Kolyshkin <kir@swsoft.com>, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take
 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>	<20071027002448.GH30533@stusta.de>	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com> <4724B4F2.7070500@goop.org>	<20071028170008.GD7227@stusta.de> <m13avvqef1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13avvqef1.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
>> On Sun, Oct 28, 2007 at 09:12:34AM -0700, Jeremy Fitzhardinge wrote:
>>> Eric W. Biederman wrote:
>>>> Roughly that sounds like CONFIG_EXPERIMENTAL to me.  But I would
>>>> be happy to hear if someone has a better idea.
>>> Rather than overload an existing config option, why not add one with the
>>> specific semantics you want: CONFIG_UNSTABLE_UABI.  The problem seems
>>> like one which which may occur again, though one hopes not too often.  I
>>> guess the risk is that people will leave their subsystems depending on
>>> it permanently (sysfs?), so it ends up being set all the time and
>>> becomes as useless as EXPERIMENTAL...
>> Then let SYSFS depend on UNSTABLE_UABI for the next 10 years and we have 
>> an excuse for breaking the ABI with each new kernel...
>>
>> Either the ABI is stable or it should not be exposed to users at all.
> 
> If we need a new config for it.  CONFIG_IMMATURE is the closest I
> can think of.

Pavel also has a CONFIG_NAMESPACES patch that he should be resending to 
andrew when 2.6.24-rc1-mm1 is released. pidns will go under this option, 
like all the other namespaces, and should protect the distros from shipping 
any immature namespace.


C.
