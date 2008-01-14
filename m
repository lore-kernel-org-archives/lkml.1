Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYANQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYANQ3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYANQ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:29:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:59090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYANQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:29:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wsKbt5VxbTwxTS6Xf6XtoJsdghX7U/SVJzAc6VjLHOwpCqt/jEDyVSSUUapHUMFY2SpV8kNV8OeXjy7MwVKlh5oCnvKEfGxuSEyW+ICmmjvEaXfpTv7o6mXlPQBiebGd7xRdoEc2Kftqn+WL11kwYL/izXDWz66co54I8fXIT1A=
Date: Mon, 14 Jan 2008 19:28:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Message-ID: <20080114162857.GC6639@cvg>
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com> <478A82AD.3070904@gmail.com> <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com> <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com> <478B7C4A.5090903@gmail.com> <20080114153806.GA6639@cvg> <478B86DA.1010902@gmail.com> <20080114160745.GB6639@cvg> <478B8D54.7010400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B8D54.7010400@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Mon, Jan 14, 2008 at 05:27:00PM +0100]
> On 01/14/2008 05:07 PM, Cyrill Gorcunov wrote:
>> Yes, process would be stopped, and not *just* stopped but could spend
>> all his cpu time-slice in attempt to get spinlock (espec if set time is
>> much longer than read), but if we use mutex here the process could just
>> sleep instead of trying to get spinlock granted. Am I wrong? Or this is
>> not worth to do it?
>
> I would say no. It'll spin only for nanoseconds there.
>

Thanks a lot Jiri, I'll resend improved patch.

		- Cyrill -
