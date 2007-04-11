Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXDKOEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXDKOEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXDKOEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:04:31 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:33522 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXDKOEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:04:30 -0400
Date: Wed, 11 Apr 2007 15:57:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Neil Brown <neilb@suse.de>
cc: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: <17947.65165.569482.976343@notabene.brown>
Message-ID: <Pine.LNX.4.61.0704111557330.32056@yvahk01.tjqt.qr>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
 <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org>
 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
 <17947.65165.569482.976343@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 07:15, Neil Brown wrote:
>On Sunday April 8, joern@lazybastard.org wrote:
>> On Sun, 8 April 2007 11:11:20 -0700, H. Peter Anvin wrote:
>> > 
>> > Well, the question is if you can keep the seekdir/telldir cookie around 
>> > as a pointer -- preferrably in userspace, of course.  You would 
>> > presumably garbage-collect them on closedir() -- there is no other point 
>> > at which you could.
>> 
>> Garbage-collecting them on closedir() does not work.  It surprised me as
>> well, but there seem to be applications that keep the telldir() cookie
>> around after closedir().  Iirc, "rm -r" was one of them.
>> 
>> Neil, is this correct?
>
>It's just NFS.  nfsd does open/getdents/close on every readdir
>request.

Uhoh, that sounds even more expensive than doing one getdent during opendir.



Jan
-- 
