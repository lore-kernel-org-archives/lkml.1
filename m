Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYKYHTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYKYHTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYKYHTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:19:41 -0500
Received: from blaine.gmane.org ([80.91.229.8]:59726 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbYKYHTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:19:41 -0500
From: Junio C Hamano <gitster@pobox.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds 
	<public-torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       Andrew Morton 
	<public-akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.28-git
References: <20081120055026.GA10709@kroah.com>
 <alpine.LFD.2.00.0811201322350.21698@nehalem.linux-foundation.org>
 <20081120214826.GA15769@suse.de> <7vprkklaob.fsf@gitster.siamese.dyndns.org>
 <20081125042051.GA17345__32159.7253824168$1227588787$gmane$org@suse.de>
Date: Mon, 24 Nov 2008 23:18:55 -0800
In-Reply-To: <20081125042051.GA17345__32159.7253824168$1227588787$gmane$org@suse.de> (Greg
 KH's message of "Mon, 24 Nov 2008 20:20:51 -0800")
Message-ID: <7v3ahgl1cw.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 5E688C92-BAC1-11DD-83AE-F83E113D384A-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH <gregkh@suse.de> writes:

> On Mon, Nov 24, 2008 at 07:57:40PM -0800, Junio C Hamano wrote:
>> 
>> Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org> writes:
>> 
>> > On Thu, Nov 20, 2008 at 01:23:51PM -0800, Linus Torvalds wrote:
>> >> ...
>> >> "Already up-to-date". 
>> >> 
>> >> I think you forgot to actually push them out.
>> >
>> > Crap, you're right, they are now there, sorry about that.
>> 
>> I've been wondering if git can do something to avoid things like this.
>> ...
> In this case, it was just my fault.  I just forgot to push the tree.  I
> have my own scripts that I use to create my "please pull" message, that
> don't really tie into git's infrastructure and I don't know if I would
> want them to either.

Oh, I wouldn't question that it was ultimately _your_ fault, but:

 (1) I see Linus mention "did you forget to push" every once in a while
     on this list (e.g. http://tinyurl.com/forgot-to-push); and

 (2) You are not the only person who sends "please pull" request and
     pushes out what needs to be pulled, and forgets to push.  Everybody
     who asks Linus to pull either needs to roll his own scripts.  This is
     wasteful, but this is partly git's fault, and something we could
     improve, because I do not think there is no usable canned tools that
     come with git that allows you to prepare a custom "please pull"
     message and helps you not to forget pushing out; and

 (3) As an early adopter who has his own wrappers around git that are
     tailored to match his own needs in this part of the workflow, you'd
     be an ideal source of requirements _if_ we would want to provide a
     usable canned tool for doing this.

Hence my comments.

