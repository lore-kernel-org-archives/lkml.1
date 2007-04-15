Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbXDOQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbXDOQzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXDOQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:55:16 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:39281 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbXDOQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t00/icm0BKu/2A39awGJKpkQBY8awO/RS9hhEg5h6KPOxPCywCeKokEZnlrhpdmIsScO0WoVEwFTwKC6jMr2iOOfIVw8Od4zq1kOQi6PyJ3lbYZ97Zh94HTjS1Mi3lLwISGo/uMw6f8M99KzxzvSllAwcOgs22czYjS7adecLKg=
Message-ID: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
Date: Sun, 15 Apr 2007 18:55:13 +0200
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Kaffeine problem with CFS
Cc: "=?ISO-8859-9?Q?S.=C7a=F0lar_Onur?=" <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>
In-Reply-To: <20070415162508.GA4526@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413202100.GA9957@elte.hu>
	 <200704141809.58737.caglar@pardus.org.tr>
	 <20070414160939.GB3099@elte.hu>
	 <200704141959.50076.caglar@pardus.org.tr>
	 <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/4/15, Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
> > > [1] http://cekirdek.pardus.org.tr/~caglar/strace.kaffeine

Could you try xine-ui or gxine? Because I suspect rather xine-lib for
freezing issues. In any way I think a gdb backtrace would be much
nicer - but if you can't reproduce the freeze issue with other xine
based players and want to run kaffeine in gdb, you need to execute
"gdb --args kaffeine --nofork".

> > thanks. This does has the appearance of a userspace race condition of
> > some sorts. Can you trigger this hang with the patch below applied to
> > the vanilla tree as well? (with no CFS patch applied)
>
> oops, please use the patch below instead.
>
>         Ingo
<snip>

Christoph
