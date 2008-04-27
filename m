Return-Path: <linux-kernel-owner+w=401wt.eu-S1763081AbYD0Wkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbYD0Wkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYD0Wk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:40:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:37163 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYD0Wk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jsfVa1yY7afnOP7TREQuJu4KXs2LQa5ecUEaKptqXCkZN7SDlVus45TON99FGTbYZW7OvSHYl0PLoe0MuPUxtNmOVNvOKgbn6SXzx8RiCSNMh1nID3xsKyeeVfjV6EzP6Es24fo3CS8ZbKEoeT2YI0ddSNgMSEQiqn9LDKURJv8=
Message-ID: <ed038eb20804271540q7df7ebe0p8e5c6b15c85813e0@mail.gmail.com>
Date: Mon, 28 Apr 2008 00:40:28 +0200
From: "Carl Henrik Lunde" <chlunde@ping.uio.no>
To: "Soeren Sandmann" <sandmann@daimi.au.dk>
Subject: Re: stat benchmark
Cc: linux-kernel@vger.kernel.org, "Zach Brown" <zach.brown@oracle.com>
In-Reply-To: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
X-Google-Sender-Auth: 16475ccdcdcab853
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 10:59 PM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
[...]
>  Under the theory that disk seeks are killing us, one idea is to add a
>  'multistat' system call that would allow statting of many files at a
>  time, which would give the disk scheduler more to work with.

Instead of a specific system call for "multistat" it would be interesting
to look at syslets.  I'm not sure what the current state of that work is,
the last reference I find is http://lkml.org/lkml/2007/12/6/336 and more
interestingly http://lkml.org/lkml/2008/1/9/327

I guess it would be difficult to get close to the optimal disk schedule by
using syslets; if a directory contains 1000 files that would require 1000
syslets and a good I/O scheduler - that's unlikely to be feasible.

I've added Zach Brown to Cc because he authored the last syslet patchset.

-- 
Carl Henrik
