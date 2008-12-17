Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757987AbYLQDVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYLQDVY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYLQDVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:21:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbYLQDVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:21:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
        ebiederm@xmission.com, daniel@hozac.com, bastian@waldi.eu.org,
        xemul@openvz.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: Re: [RFC][PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
In-Reply-To: Roland McGrath's message of  Tuesday, 16 December 2008 19:17:30 -0800 <20081217031730.F2767FC3BC@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <20081217020601.GB2866@us.ibm.com>
	<20081217031730.F2767FC3BC@magilla.sf.frob.com>
X-Shopping-List: (1) Lunatic yies
   (2) Rustic retribution eggplants
   (3) Gaunt hard-core chowder
   (4) Aberrant sensuous interruptions
Message-Id: <20081217032032.83C30FC3BC@magilla.sf.frob.com>
Date: Tue, 16 Dec 2008 19:20:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arguably these deserve a heads-up to linux-abi, not that whether si_pid was
tid or tgid was probably actually documented before (and I presume the
wrong-namespace issue just doesn't need to be).

Thanks,
Roland
