Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZIQAzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZIQAzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZIQAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:55:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51990 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZIQAzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:55:22 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 16 Sep 2009 17:55:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gilad Benjamini <gilad@altornetworks.com>
cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: epoll and closed file descriptors
In-Reply-To: <024701ca372f$81412040$83c360c0$@com>
Message-ID: <alpine.DEB.2.00.0909161747360.3124@makko.or.mcafeemobile.com>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com> <024601ca372d$09ad9fb0$1d08df10$@com> <alpine.DEB.2.00.0909161726090.3124@makko.or.mcafeemobile.com> <024701ca372f$81412040$83c360c0$@com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Gilad Benjamini wrote:

> My bad. I meant to quote the line that you mentioned.
> I agree that the right thing to do is to remove the fd from epoll before
> closing it.
> However, due to the way curl works, I cannot do that. Changing the curl code
> doesn't seem trivial.

You probably need to explain how you use libcurl together with epoll, even 
though this is not a help-userspace mailing list.


> Regardless, I still don't see how the kernel got into this situation, and if
> this situation is valid, why it doesn't bail out of it.

I think this was already explained.


- Davide


