Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbYBLIWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbYBLIWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYBLIWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:22:04 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:48727 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYBLIWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:22:01 -0500
Message-ID: <47B1571B.1090408@panasas.com>
Date: Tue, 12 Feb 2008 10:21:47 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
References: <20080210143240.GA13317@joi> <20080211102339.GD11671@shadowen.org> <47B0725C.30407@panasas.com> <20080211164046.GI11671@shadowen.org> <47B07EA0.7010708@panasas.com> <20080211184224.GJ11671@shadowen.org>
In-Reply-To: <20080211184224.GJ11671@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 11, 2008, 20:42 +0200, Andy Whitcroft <apw@shadowen.org> wrote:
> On Mon, Feb 11, 2008 at 06:58:08PM +0200, Benny Halevy wrote:
>> OK, but the return type doesn't have to be in the patched line, it could be in
>> a synchronization line or even missing if the function has a long multi-line argument
>> list.
> 
> Ok, I guess thats fair criticism.  Could you check out the current
> checkpatch-next (0.14-8-g3737366 or later -9, -10 etc), and see if
> that works.  It seems to on the simple examples you sent me :).

Confirmed with 0.14-8-g3737366.

Thanks!

Benny

Oh, and I really liked the fact that you print the patch file name
in the summary line of each patch checked rather than "Your patch" :)

> 
> Thanks.
> 
> -apw

