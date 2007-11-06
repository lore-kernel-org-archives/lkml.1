Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXKFJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXKFJZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXKFJZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:25:08 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:26008 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKFJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:25:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Co//MVkK52tDXSAboGzZBdmpgAivlq4i1k8R360XJ+F+vTm84RlGrZ1PUaQ9uZrGCFA02zTxRhZTn/ZSwhU0uTr48b65iL07/NPseD+fnKHGFBZjtbxsyV6CBmJdw8zPzFAG0ho/bYgKM+yBRKU9CUo+rRCN9OhbVt/3ryEVcis=
Message-ID: <b6a2187b0711060125u15d3a03bw803ae22d4a5211a0@mail.gmail.com>
Date: Tue, 6 Nov 2007 17:25:03 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Slab/Slub growing above 2.6.20.15 (may be...)
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 3:58 PM, Hugh Dickins <hugh@veritas.com> wrote:
> > running Oracle. It only happens with lots of activities.
>
> It would help everybody if you could get more info on this.

Ok, I'll try to log down the activities when it happens again.

> Give 2.6.24-rc2 a try when it appears, if you can.

Definitely will. Only problem is I still need vmware and cisco vpn,
and these two modules cannot compile on 2.6.24-rc1. Does anyone have a
patch for these? Last time I posted some patches for these, I got yell
at. But I need to work at the same time.

> Do you think it's the SLAB which is growing?  If /proc/meminfo's
> Slab count goes up and up, then use /proc/slabinfo to see what
> it is that's leaking.  Then there's CONFIG_DEBUG_SLAB_LEAK.

These are good tools for me to work with.

Thank you,
Jeff.
