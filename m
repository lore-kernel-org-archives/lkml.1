Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbYETSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbYETSBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYETSBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:01:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:23167 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbYETSBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WeYIV9/+3qZDcTdCjfXa7Vh8+gGWcbdWM6w6WRQVqQCVc87GYlqTaSOirnxu1tu/N+cuHtGew6749ik9aydTZefmKw67cBkmScijpaX7jnjpfW0gY7lhkJRaXpIqXq/87cnTTBjs21tD/3+8dKr2G1GXS3wM7XMeKt9AD29YGfo=
Message-ID: <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com>
Date: Tue, 20 May 2008 19:01:02 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520175624.GA10889@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
	 <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
	 <20080520161047.GA9598@c2.user-mode-linux.org>
	 <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
	 <20080520175624.GA10889@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Jeff Dike <jdike@addtoit.com>:
> On Tue, May 20, 2008 at 05:43:17PM +0100, Tom Spink wrote:
>> I suspected this type of foul-play, and tried altering bottom to 1,
>> but this didn't work.  So, I took out the page_ok test, and it
>> continued booting.  So I went back, put the test back in and
>> incremented bottom until I got to 16.  It worked at 16. :-)
>
> Heh, I guess they were also worried about up to 64K offsets off a NULL
> pointer too.

<g>

>
>> Is this something that can be fixed, or would a config option be
>> appropriate?
>
> This was done in order to remove config options.  It might be
> reasonable to effectively do what you did, and search for the lowest
> address at which mmap works and start from there.

Cool, and nice work BTW.  I just for-looped up the way, from 0.

>
>> I am willing to blame Ubuntu, but unfortunately, I can't find an
>> online resource of their patches.
>
> https://wiki.ubuntu.com/KernelGitGuide lists a bunch of git repos.
> Tell me which one applies to you and I'll take a look.
>

I'm a hardy.  I bet it's 893f802872c3.

http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy.git;a=commitdiff;h=893f802872c3e3c6e4bb40c3be4845784b81b934

>                  Jeff

-- 
Tom Spink
