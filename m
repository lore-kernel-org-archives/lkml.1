Return-Path: <linux-kernel-owner+w=401wt.eu-S935283AbYBHLcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935283AbYBHLcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbYBHLbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:31:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:29946 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbYBHLbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JHbcoSX7bXtFInzmOxST2YGS/MIlCE2vtt+q+boC2yATIzpUdL3vRga21rlyxQDYRQoUvSbRGk0rp3dDsToThiBdpB2dxu5SgQPn8/wsZMlfW7Hi8phEUu7PFYG9xOmr9x8ok3JRUIQntlRicHApe2PVaPs4LE0Aiqx92sj4sBI=
Message-ID: <84144f020802080331j5bc01bc6naf1fe0192aadf70b@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:31:44 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080208115542.GD4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <20080208115542.GD4745@one.firstfloor.org>
X-Google-Sender-Auth: a80b59b917494eea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Feb 8, 2008 1:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Impressive patch! On the other hand a lot of the interesting
> data isn't it kmalloc anymore, but in slab. Does it really track
> all that much?

It tracks all slab caches. What we're not tracking is pages from the
page allocator that are directly used by callers. We had some
discussion of this already and we definitely want to extend it to
cover that too later on.
