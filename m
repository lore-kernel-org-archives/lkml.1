Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0BAPnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:43:47 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:47301 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0BAPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pxvVKFVhYAkDXDbUsyybH0D74kqkxB8EdJj3hWtkDacmG/gcxjaVHqlqljb0TfIWhC
         L17Fn6yXC1JTuWG9sgOQUV/sHh3tnOywdZT/s24KBNrPcaXUYTiNImSIf112bVF0DsoW
         pC3JUbyNZ/kdSpHyYLMLQuzqm0hAoFi5MvtXI=
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <201002011630.04281.rjw@sisk.pl>
References: <alpine.LFD.2.00.1001221841490.2266@localhost>
	 <201001252237.42545.rjw@sisk.pl>
	 <alpine.LFD.2.00.1002011527580.5334@localhost>
	 <201002011630.04281.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 17:43:40 +0200
Message-ID: <1265039020.3785.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 16:30 +0100, Rafael J. Wysocki wrote: 
> On Monday 01 February 2010, Sebastian Ott wrote:
> > Hi Rafael,
> > 
> > since you didn't like the idea of calling the driver callbacks with just
> > one cpu enabled, we gave your patch: "MM / PM: Force GFP_NOIO during
> > suspend/hibernation and resume" a try and i can confirm that this
> > fixes the issue on s390.
> 
> Great, thanks for testing!
> 
> > Will this go in 2.6.33/stable?
> 
> That depends on Andrew, actually.
> 
> Andrew, what do you think of the patch at:
> http://patchwork.kernel.org/patch/74740/mbox/ ?
> 
> It helps people and I don't see any major drawbacks of it.

And it works too.
I will today continue the torture testing of hibernate mode, but so far
no hands.

Best regards,
Maxim Levitsky

