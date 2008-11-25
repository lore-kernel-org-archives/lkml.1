Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYKYD6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYKYD6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 22:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYKYD6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 22:58:22 -0500
Received: from blaine.gmane.org ([80.91.229.8]:44565 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYKYD6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 22:58:21 -0500
From: Junio C Hamano <gitster@pobox.com>
To: Greg KH <public-gregkh-l3A5Bk7waGM@hugh.gmane.org>
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
 <20081120214826.GA15769@suse.de>
Date: Mon, 24 Nov 2008 19:57:40 -0800
In-Reply-To: <20081120214826.GA15769@suse.de> (Greg KH's message of "Thu, 20
 Nov 2008 13:48:26 -0800")
Message-ID: <7vprkklaob.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 40F04AEA-BAA5-11DD-BCCD-F83E113D384A-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org> writes:

> On Thu, Nov 20, 2008 at 01:23:51PM -0800, Linus Torvalds wrote:
>> 
>> 
>> On Wed, 19 Nov 2008, Greg KH wrote:
>> > 
>> > Please pull from:
>> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>> 
>> "Already up-to-date". 
>> 
>> I think you forgot to actually push them out.
>
> Crap, you're right, they are now there, sorry about that.

I've been wondering if git can do something to avoid things like this.

For example, if you push into a particular branch of a particular
repository _only_ to ask Linus to pull and for no other purpose, one
possible solution may be to trigger a hook on the receiving end of your
push (i.e. the public repository Linus is asked to pull from) to send out
the "Please pull from" message (I presume this would be a no-go as there
is not much room for you to customize the message).

Alternatively, we may want to give an option to git-request-pull to
actually run "git push" to the destination.

Thoughts?  Is it "none of Git's business"?


