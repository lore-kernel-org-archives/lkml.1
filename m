Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZEWTjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZEWTjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZEWTjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:39:03 -0400
Received: from waste.org ([66.93.16.53]:41664 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZEWTjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:39:02 -0400
Subject: Re: dd if=/dev/random of=data.bin bs=512 count=1
From: Matt Mackall <mpm@selenic.com>
To: Jon <jg@jguk.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A184ABB.1070902@jguk.org>
References: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com>
	 <2f11576a0905170901x41e15f65sf10bb5ee36050d14@mail.gmail.com>
	 <4A184ABB.1070902@jguk.org>
Content-Type: text/plain
Date: Sat, 23 May 2009 14:38:07 -0500
Message-Id: <1243107487.12761.17.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 20:12 +0100, Jon wrote:
> Hello KOSAKI,
> 
> Thank you for your reply.
> 
> KOSAKI Motohiro wrote:
> >> Hello
> >>
> >> Issuing this command, I expected to get a file 4096 bytes in size.
> >> Could someone let me know if I have missed something..? Or is there a
> >> problem with using /dev/random this way?
> >>
> >> if I have a count=10 it hangs forever (several hours).
> >>
> >> Changing to use /dev/urandom and it generates the file ok.
> > 
> > you already have the answer. /dev/random might blocked, /dev/urandom doesn't.
> 
> Is this a "feature" of /dev/random ? ..it does not seem very useful to 
> have it able to block for so long.

Yes. The theory is that it will be secure even in the event of a
catastrophic failure of the cryptographic compression function. But
don't worry about that; use /dev/urandom.

-- 
http://selenic.com : development and support for Mercurial and Linux


