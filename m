Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0BRA6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:58:39 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:20536 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873Ab0BRA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:58:38 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc code
Date: Thu, 18 Feb 2010 05:58:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <4B7A5A23.3080309@redhat.com> <201002161248.56598.opurdila@ixiacom.com>
In-Reply-To: <201002161248.56598.opurdila@ixiacom.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002180258.20869.opurdila@ixiacom.com>
X-OriginalArrivalTime: 18 Feb 2010 00:58:36.0700 (UTC) FILETIME=[805FD5C0:01CAB035]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 09:48:56 you wrote:
> On Tuesday 16 February 2010 10:41:07 you wrote:
> > > +
> > > +     if (!write && !first && left && !err)
> > > +             err = proc_put_newline(&buffer, &left);
> > > +     if (write && !err)
> > > +             err = proc_skip_wspace(&buffer, &left);
> > > +     if (err == -EFAULT /* do we really need to check for -EFAULT? */
> > > || +         (write && first))
> > > +             return err ? : -EINVAL;
> >
> > The logic here seems messy, adding one or two goto's may help?
> 
> OK, I'll give it a try.
> 

After a couple of tries which didn't make it clearer, I've given up. Maybe its 
not clear, but is not too terribly messy IMO. I'll rather spend time on 
getting the new list range format done.
