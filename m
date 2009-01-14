Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbZANCDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbZANCDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbZANCDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:03:03 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:55925 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZANCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r0UJwg5+TP2Mk0BiA+W3Qu59fbfxgYUxCFPFCq/0xo1tnpUDV/XrYYHFZLjlxhceRT
         t04V2n+KIQAT90sTLlIBAOgCxlG4oyypwE8aroPKPSM0flYoHPTS3gvkRT57hFFJd+T8
         GdE6GCWa+FUcf/a83rZu7ncP1BeicBJwzRK/M=
Date: Tue, 13 Jan 2009 21:02:40 -0500
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [ltt-dev] [PATCH 1/2] Make lttctl mount debugfs automatically
Message-ID: <20090114020240.GA27672@zod.rchland.ibm.com>
References: <49646208.7070607@cn.fujitsu.com> <4964BA2B.30200@polymtl.ca> <AA3F776E5F6246859F1978B7C7CF1919@zhaoleiwin> <20090108144430.GA3778@Krystal> <7C0A417AB5B84CDCB9A9484C4E13A08C@zhaoleiwin> <20090109033021.GA25504@Krystal> <20090113235419.GA20644@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113235419.GA20644@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:54:19PM -0800, Greg KH wrote:
>On Thu, Jan 08, 2009 at 10:30:22PM -0500, Mathieu Desnoyers wrote:
>> * Zhaolei (zhaolei@cn.fujitsu.com) wrote:
>> > * From: "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
>> > >* Zhaolei (zhaolei@cn.fujitsu.com) wrote:
>> > >> * From: "Pierre-Marc Fournier" <pierre-marc.fournier@polymtl.ca>
>> > >> > Zhaolei wrote:
>> > >> >> lttctl need debugfs mounted,
>> > >> >> This patch make lttctl mount debugfs automatically when it is not mounted.
>> > >> >> 
>> > >> > 
>> > >> > Isn't having a utility such as lttctl mount filesystems against standard
>> > >> > unix semantics? Can you give an example of another standard command that
>> > >> > uses a filesystem and that tries to mount it if it isn't already
>> > >> > mounted? 
>> > >> Hello, Pierre-Marc,
>> > >> 
>> > >> I can give a an example.
>> > >> It is SystemTap.
>> > >> 
>> > > 
>> > > No offence, but can you find an example which is not explicitly
>> > > described as "bad taste" example by many people in the Linux kernel
>> > > community ?
>> > Hello, Mathieu
>> > 
>> > I can't find another example of mounting debugfs automatically.
>
>Have you looked?  openSUSE mounts it automatically, and I think Fedora
>also does so.

Fedora doesn't.  At least not with the last 3 stable releases.

josh
