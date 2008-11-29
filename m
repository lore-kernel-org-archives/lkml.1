Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYK2PF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYK2PF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 10:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYK2PFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 10:05:16 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:46371 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYK2PFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 10:05:15 -0500
Date: Sat, 29 Nov 2008 17:50:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
Message-ID: <20081129122039.GA31635@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Pekka Enberg <penberg@cs.helsinki.fi>, jdike@addtoit.com,
	linux-kernel@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net
References: <20081129100830.GA24128@balbir.in.ibm.com> <84144f020811290221g947f836n4fe3435676425ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <84144f020811290221g947f836n4fe3435676425ee@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@cs.helsinki.fi> [2008-11-29 12:21:46]:

> Hi Balbir,
> 
> On Sat, Nov 29, 2008 at 12:08 PM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> > mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
> > the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
> > a big overrun bug reported on UML bootup.
> 
> Maybe mention that ->sun_path in struct sockaddr_un is UNIX_PATH_MAX
> long which causes the problem?
>

Yes, the changelog can definitely add that to the changelog, I'll
resend the patch if Jeff asks for it.

 
> > Reported-by: Vikas K Managutte <vikki.km@gmail.com>
> > Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks!

-- 
	Balbir
