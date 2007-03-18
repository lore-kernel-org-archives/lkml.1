Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXCRGyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXCRGyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXCRGyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:54:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57396 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbXCRGyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pbn0mWz5nwcorY6djlGQ63H67liRUil3Z8Q4JjzoVNeTfGiXQxCk4yec/Yi7SxDbTmhYjk0xUuJtFOSbc3+D9u6+JVEigbhf633AHnvaEyYJTfdaDXbeiBTzmjXWJe3BXkeEcmOFozihZGFEQA5RmcIhGHXsogZPczWKiXktWFA=
Message-ID: <f44c5fdf0703172354o935e140p8a3e64411d3ffa0a@mail.gmail.com>
Date: Sun, 18 Mar 2007 07:54:20 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: is RSDL an "unfair" scheduler too?
Cc: "Willy Tarreau" <w@1wt.eu>, "Al Boldi" <a1426z@gawab.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "William Lee Irwin III" <wli@holomorphy.com>, ck@vds.kolivas.org,
       "Avi Kivity" <avi@argo.co.il>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nicholas Miell" <nmiell@comcast.net>
In-Reply-To: <1174199171.8543.1.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
	 <200703172048.46267.kernel@kolivas.org>
	 <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il>
	 <20070318012533.GB2986@holomorphy.com>
	 <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
	 <20070318052439.GT943@1wt.eu>
	 <1174199171.8543.1.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/07, Mike Galbraith <efault@gmx.de> wrote:
> On Sun, 2007-03-18 at 06:24 +0100, Willy Tarreau wrote:
>
> > Maybe we're all discussing the problem because we have reached the point
> > where we need two types of schedulers : one for the desktop and one for
> > the servers. After all, this is already what is proposed with preempt,
> > it would make sense provided they share the same core and avoid ifdefs
> > or unused structure members. Maybe adding OPTIONAL unfairness to RSDL
> > would help some scenarios, but in any case it is important to retain
> > the default fairness it provides.
>
> Bingo.
>

Sounds like Staircase's interactive mode switch, except this actually
requires writing additional code.

The per-user system would also be nice for servers, provided there are
CPU/disc IO/swapper/... quotas or priorities at least.

All in all, I'd hate to see mldonkey eating 1/3 of CPU time, just
because it runs as another user.
