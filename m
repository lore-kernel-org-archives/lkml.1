Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbYLBURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbYLBURp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYLBURg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:17:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbYLBURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:17:35 -0500
Date: Tue, 2 Dec 2008 12:17:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: penberg@cs.helsinki.fi, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
Message-Id: <20081202121707.e1623f89.akpm@linux-foundation.org>
In-Reply-To: <20081129122039.GA31635@balbir.in.ibm.com>
References: <20081129100830.GA24128@balbir.in.ibm.com>
	<84144f020811290221g947f836n4fe3435676425ee@mail.gmail.com>
	<20081129122039.GA31635@balbir.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 17:50:39 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Pekka Enberg <penberg@cs.helsinki.fi> [2008-11-29 12:21:46]:
> 
> > Hi Balbir,
> > 
> > On Sat, Nov 29, 2008 at 12:08 PM, Balbir Singh
> > <balbir@linux.vnet.ibm.com> wrote:
> > > mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
> > > the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
> > > a big overrun bug reported on UML bootup.
> > 
> > Maybe mention that ->sun_path in struct sockaddr_un is UNIX_PATH_MAX
> > long which causes the problem?
> >
> 
> Yes, the changelog can definitely add that to the changelog, I'll
> resend the patch if Jeff asks for it.

Jeff's been quiet lately - I'll merge this one.

I also tagged it for -stable, subject to Jeff's OK.  I'm wondering why
this wasn't observed in earlier kernels?

