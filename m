Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYH1SYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYH1SYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYH1SYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:24:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYH1SYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:24:35 -0400
Message-ID: <48B6ED12.206@kernel.org>
Date: Thu, 28 Aug 2008 20:23:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <E1KYm6E-0003rI-RI@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYm6E-0003rI-RI@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:24:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Guessing that CUSE stands for "Character Devices in Userspace"?

Yeap, right.

> Is there a description of this?  It's for sound device emulation,
> right?

I did it for OSS emulation but it can be used for anything.  Hmm... I'm
still in the process of pushing out patches, so please wait just a bit.
 The libfuse changes include simple examples so that should make things
 a bit clearer.

> What is direct-lseek for?  It doesn't sound like a feature needed by
> char devices.

Sound device just sets nonseekable.  The direct lseek bit is for API
completeness as there are chardevs which have special semantics
regarding lseek.

Thanks.

-- 
tejun
