Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbXLCXpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbXLCXpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXLCXpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:45:42 -0500
Received: from baron.coraid.com ([65.14.39.133]:16446 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbXLCXpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:45:42 -0500
Date: Mon, 3 Dec 2007 18:42:28 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, a.p.zijlstra@chello.nl
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-ID: <20071203234228.GG27094@coraid.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/> <20071201122302.10dd9c44.akpm@linux-foundation.org> <20071203162137.GB25251@coraid.com> <20071203113459.d36c1a01.akpm@linux-foundation.org> <20071203210005.GB27094@coraid.com> <20071203213837.GE27094@coraid.com> <20071203144722.4188f476.akpm@linux-foundation.org> <20071203151349.0ebf497c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203151349.0ebf497c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 03:13:49PM -0800, Andrew Morton wrote:
> On Mon, 3 Dec 2007 14:47:22 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Does this fix?
> 
> Slightly more elaborate version

Yes, this patch does eliminate the problem.  Without it, no write can
complete, and with it I have seen many writes complete without any
trouble.

Thank you for looking into this.  I will look more closely at this
patch tomorrow.

-- 
  Ed L Cashin <ecashin@coraid.com>
