Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYI3Wjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYI3Wjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYI3Wjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:39:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:10348 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYI3Wjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Czfv/hiMWEF0JKcOWZNWdisY7iYHmVtgpNDrW252hictgo0bvR5bcdonmJ4BQlY0V2
         pd6/+gic7di3bnjVjcJXi6z8iNFGAZ2DElC1/BQLseEUImk4STpPiXWST+xAN+nFVxci
         GDgimoXrfbXNG5Wa1qLs8IVcvUJ6mjUey/qGM=
Message-ID: <f7848160809301539i1ebc7c2ek185c1589839a3d78@mail.gmail.com>
Date: Tue, 30 Sep 2008 18:39:30 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [ksoftirqd/1] CPU reporting.
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9e4733910809300741n1da80e6ep777c39bc1373417c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910809300741n1da80e6ep777c39bc1373417c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 10:41 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
> What's up with ksoftirqd? I'm pretty sure it hasn't used 14,676 years
> of CPU time.
> Linus current git on a Q6600 64b.
>
> jonsmirl@terra:~/fs$ ps aux
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root         7 160920245  0.0 0     0 ?        S<   07:27 21133795:38
> [ksoftirqd/1]

Uh oh - Here we go again.

Rafael - time for re-reopening of
http://bugzilla.kernel.org/show_bug.cgi?id=11209 I suppose?

Parag
