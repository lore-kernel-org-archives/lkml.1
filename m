Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbXJVRsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbXJVRsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXJVRsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:48:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:47240 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXJVRsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:48:22 -0400
Message-ID: <471CE238.5040107@qumranet.com>
Date: Mon, 22 Oct 2007 19:47:36 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Crispin Cowan <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com> <20071022035954.GA30991@kroah.com>
In-Reply-To: <20071022035954.GA30991@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Oct 21, 2007 at 07:24:42PM -0700, Thomas Fricaccia wrote:
>   
>> Yes, I think Crispin has succinctly summed it up:  irrevocably closing
>> the LSM prevents commercial customers from using security modules other
>> than that provided by their Linux distributor.
>>     
>
> Any "customer" using a security model other than provided by their Linux
> distributor instantly voided all support from that distro by doing that.
>
> So, since the support is gone, they can easily build their own kernels,
> with their own LSM interfaces, and get the exact same lack of support :)
>
>   

Running a vendor kernel has the advantage of reusing all the QA work 
that has gone into that kernel.  It is very different from running 
2.6.24-rc1 (or 2.6.22.x).  Hence projects like centos: you don't get any 
support, but the likelihood of actually requiring support is lower than 
running some random kernel.

[but I agree that someone who has somehow determined that they need a 
specific LSM will probably have determined that they need vendor support 
as well]

-- 
error compiling committee.c: too many arguments to function

