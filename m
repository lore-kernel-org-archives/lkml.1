Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZBZQge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZBZQge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbZBZQgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:36:23 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42080 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZBZQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:36:22 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 26 Feb 2009 08:36:19 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tony Battersby <tonyb@cybernetics.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] [-mm] epoll: remember the event if epoll_wait returns
 -EFAULT
In-Reply-To: <49A42E3F.1010005@cybernetics.com>
Message-ID: <alpine.DEB.2.00.0902260834150.31638@alien.or.mcafeemobile.com>
References: <49A42E3F.1010005@cybernetics.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tony Battersby wrote:

> If epoll_wait returns -EFAULT, the event that was being returned when
> the fault was encountered will be forgotten.  This is not a big deal
> since EFAULT will happen only if a buggy userspace program passes in a
> bad address, in which case what happens later usually doesn't matter.
> However, it is easy to remember the event for later, and this patch
> makes a simple change to do that.

It doesn't really matter with an EFAULT coming, anyway ...

Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


