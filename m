Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbYBFKoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbYBFKoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbYBFKnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:43:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:6052 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbYBFKnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:43:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F+t3mlcTsOHzJ3oL2bYk+dT3OznNj+bD3nQvX6khT1GkoAVSwJy7fzCmFvdaAVWjdSMgxL+n1ob8SiE53oZW0Kgzo12xb0U2n+BMOkKN/vp+llN2KvXbroNFeB6m9zUo5FPRIA4YO23lvLUD9z0G7LY5VStRElLA2pG3+iyTzvU=
Message-ID: <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com>
Date: Wed, 6 Feb 2008 18:43:51 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: where is the capset kernel module?
In-Reply-To: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2008 4:13 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> Latest linux git complained about this ...
>
> named: capset failed: Operation not permitted: please ensure that the
> capset kernel module is loaded.  see insmod(8)

How this started was that with the latest git linux, I got this warning ...

warning: `named' uses 32-bit capabilities (legacy support in use)

So, I recompile named and ended up with the "capset failed" problem. I
tried compiling linux with LSM, but that didn't help.

Adding "--disable-linux-caps" to named compile solved the problem.

Thanks,
Jeff.
