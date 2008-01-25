Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYAYXaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYAYXaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYAYXaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:30:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:19713 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYAYX37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:29:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pquF4k2AkytFGlwPAPnVvB2/BeryCZSk6zdT9b6zYk94jg+YYt+g1gv3cxe4CtR2sSx4gr6saWOc8p1XAzqODYdyQmNYF7PvJtxg3kmNPw7pwa2j45mzEUO4kVA/7NFwOXETxcB9t9mca5OjBKZrIaUn0ZrTR+kAkLQo7aZvNPc=
Message-ID: <75b66ecd0801251529s341ab6f6n2c8c56850b9ba883@mail.gmail.com>
Date: Fri, 25 Jan 2008 18:29:58 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: tickless/dynticks + cpufreq = tsc unstable
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <479A6A96.7060805@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479A6A96.7060805@msgid.tls.msk.ru>
X-Google-Sender-Auth: 2fc8eb292dd59b69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 6:02 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Is it normal that once I enable cpufreq on
> a tickless system, it spews a warning:
>
> Clocksource tsc unstable (delta = -288201154 ns)
>
> ?

Yes, it's normal.  Dual core AMD64 machines really do have unstable TSC.

Lee
