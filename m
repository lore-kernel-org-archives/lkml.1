Return-Path: <linux-kernel-owner+w=401wt.eu-S1764803AbYD2PWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764803AbYD2PWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761996AbYD2PVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:21:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907AbYD2PVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:21:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=MJ2ufw84sp4gHvgVktCssYtUF1OwqWCbvJzU/SEnwLhgqzfA5AUp3hkuXNC7xZWXm
	IoEELmHj8PGNIXqM6KHnw==
Message-ID: <d43160c70804290821i2bb0bc17m21b0c5838631e0b8@mail.gmail.com>
Date: Tue, 29 Apr 2008 11:21:40 -0400
From: "Ross Biro" <rossb@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
Cc: "Hugh Dickins" <hugh@veritas.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
	 <Pine.LNX.4.64.0804291447040.5058@blonde.site>
	 <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:52 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>  Hmm.. strange.. I don't remember the overhead being so bad (I'll
>  relook at my old numbers). I'll try and git-bisect this one

I'm checking 2.6.24 now.  A quick run of 2.6.25-rc9 without fake numa
showed no real change.

    Ross
