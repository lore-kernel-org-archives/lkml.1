Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXEaIPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXEaIPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXEaIPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:15:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:52845 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXEaIPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=B5RKmJhTdsiYSnecfDUD2nWI/nJhyoT6cyq+aVIoSxzsMmFfCg2fgKZn4AJHQeQXMclrj6iM6Xw2l01V3YyCrGZYDwZiC9DBxq+nYQoDS69iMtdQhKyPu4Ydu+eOK7QNNXvhCOKS0wc0g0lLsGlCcC28t08a2QzBOpR0A8P73jU=
Message-ID: <787b0d920705310115n13b4dd3bk59e1072dea147724@mail.gmail.com>
Date: Thu, 31 May 2007 04:15:12 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       jeff@garzik.org, zach.brown@oracle.com, arjan@infradead.org,
       hch@infradead.org, drepper@redhat.com, akpm@zip.com.au,
       alan@lxorguk.ukuu.org.uk
Subject: Re: Syslets, Threadlets, generic AIO support, v6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> looking over the list of our new generic APIs (see further below) i
> think there are three important things that are needed for an API to
> become widely used:
>
>  1) it should solve a real problem (ha ;-), it should be intuitive to
>     humans and it should fit into existing things naturally.
>
>  2) it should be ubiquitous. (if it's about IO it should cover block IO,
>     network IO, timers, signals and everything) Even if it might look
>     silly in some of the cases, having complete, utter, no compromises,
>     100% coverage for everything massively helps the uptake of an API,
>     because it allows the user-space coder to pick just one paradigm
>     that is closest to his application and stick to it and only to it.
>
>  3) it should be end-to-end supported by glibc.

4) At least slightly portable.

Anything supported by any similar OS is already ahead, even if it
isn't the perfect API of our dreams. This means kqueue and doors.

If it's not on any BSD or UNIX, then most app developers won't
touch it. Worse yet, it won't appear in programming books, so even
the Linux-only app programmers won't know about it.

Running ideas by the FreeBSD and OpenSolaris developers wouldn't
be a bad idea. Agreement leads to standardization, which leads to
interfaces getting used.

BTW, wrapper libraries that bury the new API under a layer of
gunk are not helpful. One might as well just use the old API.
