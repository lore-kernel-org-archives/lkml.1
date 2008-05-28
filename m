Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYE1CcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYE1CcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYE1CcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 22:32:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYE1CcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 22:32:11 -0400
Date: Wed, 28 May 2008 04:40:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call_usermodehelper() increase reliability
Message-ID: <20080528024053.GA20824@one.firstfloor.org>
References: <20080527212423.9CAD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527212423.9CAD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 09:30:34PM +0900, KOSAKI Motohiro wrote:
> Now, call_usermodehelper_setup() uses GFP_ATOMIC.
> but it can return NULL _very_ easily.
> 
> GFP_ATOMIC is needed only when we can't sleep.
> and, GFP_KERNEL is robust and better.
> 
> thus, I add gfp_mask argument to call_usermodehelper_setup().

Patch looks good to me. Thanks for fixing this properly.

-Andi
