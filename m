Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZEWTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZEWTUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZEWTUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:20:10 -0400
Received: from solo.fdn.fr ([80.67.169.19]:56985 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZEWTUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:20:09 -0400
Date: Sat, 23 May 2009 21:20:08 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jon <jg@jguk.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dd if=/dev/random of=data.bin bs=512 count=1
Message-ID: <20090523192008.GD10166@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jon <jg@jguk.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org
References: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com> <2f11576a0905170901x41e15f65sf10bb5ee36050d14@mail.gmail.com> <4A184ABB.1070902@jguk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A184ABB.1070902@jguk.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon, le Sat 23 May 2009 20:12:59 +0100, a écrit :
> KOSAKI Motohiro wrote:
> >>Issuing this command, I expected to get a file 4096 bytes in size.
> >>Could someone let me know if I have missed something..? Or is there a
> >>problem with using /dev/random this way?
> >>
> >>if I have a count=10 it hangs forever (several hours).
> >>
> >>Changing to use /dev/urandom and it generates the file ok.
> >
> >you already have the answer. /dev/random might blocked, /dev/urandom 
> >doesn't.
> 
> Is this a "feature" of /dev/random ?

It is, as opposed to urandom

> ..it does not seem very useful to have it able to block for so long.

The feature is about to wait for random data to be available, not only
pseudo-random data.

Samuel
