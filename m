Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYISRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYISRxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYISRxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:53:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:39955 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYISRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PJyxnQG3TwkMP9l2FVylnPJMq2pKo8vA31wS8ydM6xu0zBKkjjf97LI3za1oQJQC2n
         /6Y1J47uOFjqKM3mmQNVVhM7PhsF00lLeXtp0wLzk9azZOasTd/xv7T1ThSmiUq5LAns
         T4JOrHlHjrjiuphGyUkhQuPVVSR77DSyKl2yo=
Date: Fri, 19 Sep 2008 21:55:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Russ Dill <russ.dill@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement
	ARRAY_SIZE().
Message-ID: <20080919175544.GA3228@x200.localdomain>
References: <20080918132447.516309749@fluff.org.uk> <20080918150624.GA3421@x200.localdomain> <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com> <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com> <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 08:28:45AM -0700, Russ Dill wrote:
> My vote is for ARRAY_AND_SIZE to spread far and wide across the land.
> ARRAY_SIZE is already very safe, as it has a __must_be_array macro
> built in. So ARRAY_AND_SIZE is even safer, as it prevents you from
> mixing up two different arrays. It also reduces line length and makes
> driver and device (usually platform_device) registration code easier
> to read.

It also spreads ARRAY_SIZE misnaming futher.

It introduces one more core macro and quite pointless one. I can't
personally recall a single bug where sizeof() was taken from another
array.

It creates interesting confusion point: ARRAY_AND_SIZE is about array
and it's size. What ARRAY_SIZE is about then?

You want default argument values in fact, but C is C.

	Alexey "(array (nr (length array)))" Dobriyan
