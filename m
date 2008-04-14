Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYDNSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYDNSCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYDNSCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:02:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50646 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYDNSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:02:10 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 14 Apr 2008 11:02:08 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>,
       Jeff Roberson <jroberson@chesapeake.net>
Subject: Re: [patch] eventfd/kaio integration fix
In-Reply-To: <6101e8c40804141056rff5a160jcabb3deebf9b7b6f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804141059280.20665@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com> 
 <6101e8c40804130529k353a46a9h8ed1b5fbf6451297@mail.gmail.com> 
 <Pine.LNX.4.64.0804131555550.12741@alien.or.mcafeemobile.com>
 <6101e8c40804141056rff5a160jcabb3deebf9b7b6f@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Oliver Pinter wrote:

> this race presented in forigen kernels or only in 2.6.25-rcX?

"Forigen"?
The race is there since day one of kaio+eventfd integration. So basically, 
if your kernel has eventfd, it has also the race.
Needless to say, simple kaio usage w/out eventfd, is fine.



- Davide


