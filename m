Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbYBWSHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbYBWSHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYBWSGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:06:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59464 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYBWSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:06:52 -0500
Date: Sat, 23 Feb 2008 20:06:51 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 0/8]: uninline & uninline
In-Reply-To: <p734pbz95lx.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0802232003380.30001@kivilampi-30.cs.helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <20080223000220.e9229c99.akpm@linux-foundation.org> <p734pbz95lx.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Andi Kleen wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> 
> >> -41525  2066 f, 3370 +, 44895 -, diff: -41525  IS_ERR 
> >
> > This is a surprise.  I expect that the -mm-only
> > profile-likely-unlikely-macros.patch is the cause of this and mainline
> > doesn't have this problem.
> 
> Shouldn't they only have overhead when the respective CONFIG is enabled?

I uninlined those with allyesconfig. I'll anyway try later on without a 
number of debug related CONFIGs.


-- 
 i.
