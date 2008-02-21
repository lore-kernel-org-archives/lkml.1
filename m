Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbYBUTnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbYBUTnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYBUTnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:43:24 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:48129 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYBUTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:43:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=XZvRqn3LddymV6Ex0TwvOLwjZuijGvgpZcXTC0oyUuPcD0+Su5L4CMGQEw5RHwgr5jysEk/3hv5GqoZ3tDT5tAanlFCK2g3fzBaZ06c7+JvGjs/fyUC9vU2N6GHGBsnUaYofwDDIgUyBUga9nDQ/8Ha10P0KVEvMLicSUdsHa2Q=
Message-ID: <47BDD455.9090909@gmail.com>
Date: Thu, 21 Feb 2008 14:43:17 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly	resolved
References: <47BDA141.70806@gmail.com> <Pine.LNX.4.44L0.0802211134040.4528-100000@iolanthe.rowland.org> <20080221171726.GA30927@kroah.com>
In-Reply-To: <20080221171726.GA30927@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/2008 12:17 PM, Greg KH wrote:

> On Thu, Feb 21, 2008 at 11:36:23AM -0500, Alan Stern wrote:
> 
>> On Thu, 21 Feb 2008, Andrew Buehler wrote:

[Greg KH]
>>> I know he's in the CC:, but I'm not sure he's reading this
>>> thread, and I'm hesitant to bother people about things out of the
>>> blue unless I have reason to expect that it's something they're
>>> going to care about. (Just because it's a big deal for me doesn't
>>> mean it makes one whit of difference to anyone else, and from
>>> what little I've seen on linux-kernel he seems to be somewhat
>>> important and fairly busy...)
>> 
>> In this case you shouldn't worry about it.  I don't know whether
>> Greg has been following this thread either, but I do know that he
>> spends a lot of time and effort trying to improve vendors' support
>> for Linux. This is right up his alley.  What I'm not sure about is
>> the extent of his influence over Novell...
> 
> Heh, yes, I've been reading this.
> 
> It sounds like an old version of a Novell product is making a newer
> kernel spit out a warning message.

Originally that was all that it was, but now I am seeing the product in
question not even see the hard drive despite the fact that it is
mountable with standard utilities. Whether the failure is in the program
or elsewhere I don't know, but I'm hoping it's in the program, because
if it's elsewhere I have a *lot* of tedious digging and testing ahead of
me and little real idea of where to start.

> Odds are this is fixed in a newer one,

I haven't been able to find a newer version of the program, and do not
have the standing with my organization to contact Novell on their
behalf. (When I brought the idea up with the people who do have such
standing, in another context, the answer I received was essentially
"wait until we upgrade the servers to that version, which will not be
soon".) I also have not been able to find a clear contact path in any
case.

> as well as the basic issue that Novell doesn't even ship anything
> based on the 2.6.24 kernel yet, so perhaps the Zenworks developers
> don't even know of the issue, that's what bugzilla.novell.com is for
> :)

The problem has been present at least since 2.6.23.x and I think since
2.6.18, but from what I've been able to find Novell's last kernel was
based on 2.6.16.

I didn't even know there *was* a bugzilla.novell.com - and I've been
digging around Novell's site (and Googling around it from outside) for
what seems to me like quite a while. From the looks of things, however,
they don't have a category for ZENworks or for imaging, and the Linux
I'm using is not one of the SUSE-based distros they do list. (The
environment on the boot disc itself doesn't really qualify as any kind
of distro at all.)

Unfortunately, from what I've seen elsewhere it looks as if they are A:
not interested in supporting use any Linux except for their own SUSE for
this purpose and B: not likely to be open to supporting or even helping
with a customized environment; all of their technical documentation on
the subject is geared towards adding files and drivers to their existing
environment, not to replacing the entire kernel of that environment or
working with the results. Given that I'm building complete replacement
kernels and customizing rather a number of other things in the end
product, I'm rather inclined to suspect that even if I got into contact
with them about this they would say something to the effect of "since
you're not using our official environment, we won't/can't spend time and
effort trying to help you".

-- 
    Andrew Buehler
