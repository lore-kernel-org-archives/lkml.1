Return-Path: <linux-kernel-owner+w=401wt.eu-S1765849AbYD2QFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765849AbYD2QFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYD2QFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:05:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48028 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbYD2QFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:05:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OXdO82Vb5z5lDJuD3D4uAlTBLGzbsNsrefc8XQdJ1ciUFP/vqWUFq4sFGQiMB0Piz
	hdjgIgW1kCpOyqjetfOzQ==
Message-ID: <d43160c70804290905m1e451435q2766f552f2b6767c@mail.gmail.com>
Date: Tue, 29 Apr 2008 12:05:12 -0400
From: "Ross Biro" <rossb@google.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0804291629410.23101@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
	 <Pine.LNX.4.64.0804291447040.5058@blonde.site>
	 <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com>
	 <d43160c70804290821i2bb0bc17m21b0c5838631e0b8@mail.gmail.com>
	 <Pine.LNX.4.64.0804291629410.23101@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:32 AM, Hugh Dickins <hugh@veritas.com> wrote:
>> I'm checking 2.6.24 now.  A quick run of 2.6.25-rc9 without fake numa
>> showed no real change.
>

2.6.24 is slower as well.  I can't say for sure it's the full 10%
without more work than it's worth.  But it is definitely significantly
slower than 2.6.23.

    Ross
