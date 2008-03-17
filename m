Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYCQD4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYCQD4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYCQD4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:56:22 -0400
Received: from mail.lang.hm ([64.81.33.126]:58796 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYCQD4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:56:22 -0400
Date: Sun, 16 Mar 2008 20:59:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803161942.01944.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803162052160.14887@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803161457.04580.phillips@phunq.net> <47DDC9EC.4060208@davidnewall.com> <200803161942.01944.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008, Daniel Phillips wrote:

> On Sunday 16 March 2008 18:31, David Newall wrote:
>> Daniel Phillips wrote:
>>> The UPS provides a guarantee of commit to stable storage.  No amount of
>>> FUD will change that.
>>
>> What about system crashes?  They guarantee that data will be lost.  I
>
> Not if it is mirrored and replicated.  Also nice if crashes are very
> rare, which they are unless you work at it.

if you are depending on replication over the network you have just limited 
your throughput to your network speed and latency. on an enterprise level 
machine the network can frequently be significantly slower than the disk 
array that you are so frantic to avoid waiting for.

David Lang
