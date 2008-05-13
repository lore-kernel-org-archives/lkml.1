Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYEMHKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYEMHKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYEMHKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:10:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:20423 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYEMHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SLNlVYhOG9S7p7mCYSpYltdo74WR11Vb0fC5coUrQoVVp5U0gOyLMGLDHjjrW0auDr1XhpNx2pt8CmgMCheBjq/Br1MCNlV8dRKVfJYbcNoaAx2p02dwm8gvxkBqZ+VGKCGRhnsnvZUtyjzO0eXglNollFMRWa1VF1GpE4S5zno=
Message-ID: <386072610805130009u1e3d5adbpeb3f54017063caea@mail.gmail.com>
Date: Tue, 13 May 2008 15:09:52 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 4/4] [MM/NOMMU]: Export two symbols in nommu.c for mmap test
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org,
       "Vivi Li" <vivi.li@analog.com>
In-Reply-To: <8bd0f97a0805120602n367099a9j3b1b0a8f801877e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	 <1210588325-11027-5-git-send-email-cooloney@kernel.org>
	 <8bd0f97a0805120338l1d7e0e7eiffebae3bf33c172c@mail.gmail.com>
	 <20080512130058.GA8981@infradead.org>
	 <8bd0f97a0805120602n367099a9j3b1b0a8f801877e6@mail.gmail.com>
X-Google-Sender-Auth: 93ca903afa07cd73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 9:02 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, May 12, 2008 at 9:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
>  > Yeah, even the url pointer to there is totally unreadable.  I still
>  > don't understand why you want to export this symbols.  Also please make
>  > sure to always submit the code actually using the exports in the same
>  > patchkit, that makes it a lot easier to figure.
>
>  the symbols are exported for MMU already.  this brings the no-MMU code in line.
>  -mike
>

Right, the same symbols are exported in mm/memory.c for MMU arch.
While for NOMMU arch, Vivi (one of our tester) asked for this exported
symbols for some mmap test case.
And maybe they are useful for others.

Sorry for the misleading URL, I add to wrong patches. If you think
this patch is OK, I will rewrite the git log.

Thanks
-Bryan
