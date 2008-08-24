Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYHXI6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYHXI6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHXI6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:58:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:49457 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYHXI6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tUGwDAVBgDMnqKMN09QbZjQsFwpZh1qJGGC7iFi+vNrYkBG2ViWtgB3ViYgsZNIH1C
         ByTI9LrlcpP4qdjMlR9ZgSWsJYmLz6jQN+U/8buN9RcYOIDn2mmrZejnWgT46qZkViJG
         R05OFlNiPvMZ/kiTEFKBACjmoTQObA+7uSu/g=
Message-ID: <86802c440808240158qe35c6ddrc2774d19dc78a96@mail.gmail.com>
Date: Sun, 24 Aug 2008 01:58:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808240143y10b143c6s6f2b6753490d652f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
	 <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
	 <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
	 <86802c440808240122r64ac91beu68e7782d5056bbb3@mail.gmail.com>
	 <19f34abd0808240143y10b143c6s6f2b6753490d652f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 1:43 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
dy...
>
> Yes, the v2.6.27-rc4 boots fine. I was wondering if you knew that this
> problem had occurred in the past (and if so, which commits I can
> cherry-pick to fix it). But I guess there is not much to do. It is
> also hard to test this same config with newer kernels, because
> something in the Kconfig changed in an incompatible way (e.g. NUMAQ
> setting changes when I change kernel versions).

a lot of changes on that section code in 2.6.27.

and according to old code, you are not supposed to use numaq enabled
kernel on non-numaq HW.
but from 2.6.27-rc1 you could do that. we made the code probe the
subarch and will fall back to default or bigsmp

YH
