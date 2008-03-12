Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYCLDns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYCLDns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYCLDnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:43:41 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47073 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYCLDnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:43:41 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: Dave Hansen <haveblue@us.ibm.com>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 20:43:30 -0700
Message-Id: <1205293410.9828.65.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 10:37 +0900, penguin-kernel@i-love.sakura.ne.jp
wrote:
> I encountered
> 
>   BUG: unable to handle kernel paging request at de92efe8
>   IP: [<c017e0bb>] mnt_want_write+0x40/0x5f
> 
> 2.6.25-rc5 works fine.
> 
> Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.25-rc5-mm1

I'm not seeing anything jump out at me about what this bug might be.
Could you give me a little bit more information on your setup?

I see you're running with an inird.  Are you doing anything funky like
pivoting over to a nfs root?  Could you send me the initrd you are
using?  I might as well just try and boot with it.

-- Dave

