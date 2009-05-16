Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZEPQDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZEPQDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 12:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZEPQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 12:03:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:40647 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZEPQDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 12:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ZCNQGs/hk7bhIYvVfxv3AISvgr4ZOU5pYhwVbXHrZZJWfGXDQxk9e4ytRq6ZGbJKIx
         uwbbW6rVE0EpKtFTWFhBdBZDrmz9EAbLWuzQYqamQSnACS16I2+M9g7qMaO7Jx8dbRuH
         Y+U0+yL6bA3Ica+skBoWXlNfw8wYzYtQb07eM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0905151533070.13433@qirst.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> 
	<2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com> 
	<alpine.DEB.1.10.0905151533070.13433@qirst.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sat, 16 May 2009 09:03:16 -0700
X-Google-Sender-Auth: 69ef88a3dcdb4fc7
Message-ID: <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Satish Eerpini <eerpini@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 12:33 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Fri, 15 May 2009, Ray Lee wrote:
>
>> Which kernel version? If it's something recent, your programs may be
>> getting swapped out due to a flaw in the latest kernels, where it
>> accidentally prefers caching file data over mapped pages. If that's
>> the case, Rik (cc:d) is working on patches to address the issue, and
>> may appreciate another tester.
>
> Please keep me in the loop. I'd be interested if those patches work and
> what effect they have.

Whoops, looks like Wu Fengguang (cc:d), not Rik, has been working on
those patches. See the messages starting with "[PATCH 0/3] make mapped
executable pages the first class citizen" [
http://lkml.org/lkml/2009/5/16/23 ]

Wu: The original reporter in this thread, Satish Eerpini, is reporting
interactivity problems that sound very much like mapped executables
are getting paged out while doing large copies. I suggested that
perhaps he'd like to try out your patches to see if it addresses his
problem. His original message is reproduced below. Later in the
thread, he said 2.6.26 was fine, 2.6.27 & .28 were not.

> Hello everyone,
>
> I am trying to figure out why the Linux desktop becomes overly
> unresponsive whenever there is a file copy going on, this happens to a
> large extent with GUI based file copying, and some lesser, but with
> command line copying too.
> does it have anything to do with the kernel ??,
> if it does help, then I am running Fedora 10 on a Hp nx 7400, Centrino
> Duo processor.
>
> Cheers
> Satish
> --
> http://satish.playdrupal.com
