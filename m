Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXF0Wrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXF0Wrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbXF0WrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:47:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35804 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527AbXF0WrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:47:22 -0400
Message-ID: <4682E8E1.6090701@novell.com>
Date: Wed, 27 Jun 2007 15:46:57 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Sean <seanlkml@sympatico.ca>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
References: <20070626230756.519733902@suse.de>	<20070626165202.bfe8e6df.akpm@linux-foundation.org>	<20070627022403.GB14656@suse.de>	<20070626194700.5b0ff477.akpm@linux-foundation.org>	<20070627151114.GM1094@stusta.de>	<4682D13C.6060107@novell.com> <20070627172940.1cabd5c4.seanlkml@sympatico.ca>
In-Reply-To: <20070627172940.1cabd5c4.seanlkml@sympatico.ca>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sean wrote:
> On Wed, 27 Jun 2007 14:06:04 -0700
> Crispin Cowan <crispin@novell.com> wrote:
>   
>> I am hoping for a reconciliation where the people who don't like
>> AppArmor live with it by not using it. AppArmor is not intended to
>> replace SELinux, it is intended to address a different set of goals.
>>     
> You keep saying that.   But for that to be true you'd have to believe
> _everyone_ using Novell distributions has needs that align exactly
> with AppArmor.  Otherwise, how to explain that you don't offer and
> support both SELinux and AppArmor to your users?
>   
They are meant to co-exist in the Linux kernel source tree.

It is a fact that there exist use cases where AppArmor is incapable of
meeting the need and SELinux is just the right thing. It is Novell's
business judgment that there are not enough of those situations in our
customer base to be worth the additional expense at this time.

But we do not want to prevent other people from using SELinux if it
suits them. Linux is about choice, and that is especially vital in
security. As Linus himself observed when LSM was started, there are a
lot of security models, they have various strengths and weaknesses, and
often are not compatible with each other. That is why it is important
that LSM persist, that SELinux not be the only in-tree user of LSM, and
why we think AppArmor should be included upstream, so that non-SUSE
users can also use AppArmor if it suits them.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

