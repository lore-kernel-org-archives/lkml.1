Return-Path: <linux-kernel-owner+w=401wt.eu-S1765439AbZDBQac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765439AbZDBQac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZDBQaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:30:18 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:4249 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbZDBQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ct84/DkngUzI5E61V+1hGYKsBIGC4ttgPHlxgLtNvgGHYsoj8/UjKWN2NKuiAy1s0w
         Y1k4LFaTgNgKzcRXpsVRAYQaivQVoadfK/K5PZasrv2TcHsiB7jiNX/9QIPudVxo7iN+
         qgRMIIssPlIaGx+6T22hhLPICtGDNt5Csl6ds=
MIME-Version: 1.0
In-Reply-To: <20090402110532.GA5132@aniel>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> 
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> 
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> 
	<20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> 
	<20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> 
	<20090402110532.GA5132@aniel>
Date: Thu, 2 Apr 2009 09:29:59 -0700
Message-ID: <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 4:05 AM, Janne Grunau <j@jannau.net> wrote:
>> Current kernels just have too much IO latency
>> with ext3 it seems.
>
> MythTV calls fsync every few seconds on ongoing recordings to prevent
> stalls due to large cache writebacks on ext3.

Personally that is also one of my MythTV pet peeves.  A hack added to
MythTV to work around a crappy ext3 latency bug that also causes these
large files to get heavily fragmented.  That and the fact that yo have
to patch MythTV to eliminate those forced fdatasyncs - there is no
knob to turn it off if you're running MythTV on a filesystem which
doesn't suffer from ext3's data=ordered fsync stalls.

-Dave
