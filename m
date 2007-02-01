Return-Path: <linux-kernel-owner+w=401wt.eu-S1422732AbXBARNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422732AbXBARNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422740AbXBARNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:13:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422732AbXBARNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:13:50 -0500
Date: Thu, 1 Feb 2007 17:13:25 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>,
       Adrian Bunk <bunk@stusta.de>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
Message-ID: <20070201171325.GD10050@ftp.linux.org.uk>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de> <58cb370e0702010512j51cc2d06w6ffa6df12bbc99f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cb370e0702010512j51cc2d06w6ffa6df12bbc99f6@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 02:12:22PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On 31 Jan 2007 11:08:14 +0100, Andi Kleen <ak@suse.de> wrote:
> >Greg KH <greg@kroah.com> writes:
> >>
> >> What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> >> that floppy.c is?  Do you want everyone just to run screaming from
> >> kernel development never to be seen again?
> 
> floppy.c is not really that ugly or complicated...
> 
> It just needs some care:
> 
> * cleanup of the over-usage of macros (DP macro etc)
> * DocBook documentation would be nice
> * make debugging printks optional by using macros in a smart way
>  (see libata code for examples)
> * tracking and fixing current regressions
 
* piece of shit FSM buried in various continuation methods.
* one hell of a problem with regression testing.
