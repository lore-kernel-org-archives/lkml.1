Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbXIZSvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbXIZSvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbXIZSve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:51:34 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:51014 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbXIZSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:51:33 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: __kernel_vsyscall () hangs in SIGCHLD handler
Date: Wed, 26 Sep 2007 11:51:15 -0700
User-Agent: KMail/1.9.6
Cc: "Ulrich Drepper" <drepper@gmail.com>
References: <200709260757.20478.jzb2@aexorsyst.com> <a36005b50709261003j923835fu621882c54706d476@mail.gmail.com>
In-Reply-To: <a36005b50709261003j923835fu621882c54706d476@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709261151.15967.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007 10:03:33 Ulrich Drepper wrote:
> On 9/26/07, John Z. Bohach <jzb2@aexorsyst.com> wrote:
> > Is there some reason that syslog() sleeps in __kernel_vsyscall()
> > when invoked from a signal handler?
>
> Only very few functions are allowed to be called from signal
> handlers. This is clearly spelled out in the POSIX spec.  Section XSH
> 2.4.3 lists the allowed functions.  syslog of course is not on it. -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thank you for this information...also thanks to Giacomo who answered me 
offline...

--john
