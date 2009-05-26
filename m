Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZEZXIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZEZXIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZEZXH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:07:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49394 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZEZXH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:07:57 -0400
Date: Wed, 27 May 2009 01:14:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090526231428.GK846@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090526160017.98fc62e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526160017.98fc62e4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:00:17PM -0700, Andrew Morton wrote:
> dump_write() doesn't seem right, either.  If ->write() returns, say,
> 100 then the dump should keep on going.  At present it treats this
> return as an error.

I think that's correct actually. Short write typically means serious 
issue like disk full or broken pipe, so stopping is good.

> I wonder why the signal problem has just turned up now - did we change
> the pipe code or something?

No idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
