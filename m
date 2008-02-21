Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYBUIXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYBUIXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYBUIXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:23:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:41819 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYBUIXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pl+8o8cGRBkHbY/T1pbfPkJbhBoEXatlppMy8ffJQ7l9k8hhx+5Y49WypgntYOxHBogQNz5HyCv6poNx0qoriUTLRxSVYxaxGKRSyXfEEC7F2Nyf/C96GsPHbpaSRqoguhGj5SQtv6pvo14YZZ66FFVB1sY66VmFvCIi3Z/O9Co=
Date: Thu, 21 Feb 2008 08:23:57 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] APM is hidden in menuconfig
Message-ID: <20080221082357.GB3919@ff.dom.local>
References: <20080220120828.GD3885@ff.dom.local> <200802210123.44367.rjw@sisk.pl> <E1JS02I-0003gO-Py@faramir.fjphome.nl> <200802210221.52765.rjw@sisk.pl> <20080221074346.GA3919@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221074346.GA3919@ff.dom.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 07:43:46AM +0000, Jarek Poplawski wrote:
...
> ...Or at least to mention APM in SUSPEND title and description.
> Actually, this is really strange: both SUSPEND and PM_SLEEP have
> default = y. So it seems they are intended to be more "advertised"
> than they are?

Now I see it could be even stranger: it *is* visible by default(!)
after make defconfig. make menuconfig does something else: it seems
to "help me" and sees some other config (current kernel is in other
directory) even after deleting .config and make mrproper. So, maybe
this started because of this and the problem is with changing this
back.

Jarek P.
