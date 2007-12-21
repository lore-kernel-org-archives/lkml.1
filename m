Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXLUIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXLUIfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 03:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXLUIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 03:35:35 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:33951 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXLUIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 03:35:35 -0500
Message-ID: <476B7ACF.8020602@nigel.suspend2.net>
Date: Fri, 21 Dec 2007 19:35:27 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
In-Reply-To: <1198222399.1965.15.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Huang, Ying wrote:
> This patchset provides an enhancement to kexec/kdump. It implements
> the following features:
> 
> - Backup/restore memory used both by the original kernel and the
>   kexeced kernel.

Why the kexeced kernel as well?

[...]

> The features of this patchset can be used as follow:
> 
> - Kernel/system debug through making system snapshot. You can make
>   system snapshot, jump back, do some thing and make another system
>   snapshot.

Are you somehow recording all the filesystem changes after the first
snapshot? If not, this is pointless (you'll end up with filesystem
corruption).

[...]

> - Cooperative multi-kernel/system. With kexec jump, you can switch
>   between several kernels/systems quickly without boot process except
>   the first time. This appears like swap a whole kernel/system out/in.

How is this useful to the end user?

Regards,

Nigel


