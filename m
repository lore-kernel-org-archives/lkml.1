Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYBNFi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYBNFi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYBNFiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:38:46 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:18911 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYBNFip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=r2A6n5+GAjIeIPAmL7hNWqYg6VGVs7ZBBvLhqwXK2uD3GpZDJXm658hYoSgvqcKVJBRtj2SiqBxL13I6Kpek8utd0yPiVy+BmxKwndUUA1Ahj+Zlsj+Qzubort3ehrVTUNw4gq4S/uYB8FmSVzm9HZfn0jX7FizVYJvtT/d4jkQ=
Message-ID: <47B3D3DD.3070405@gmail.com>
Date: Thu, 14 Feb 2008 14:38:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Max Krasnyansky <maxk@qualcomm.com>, rusty@rustcorp.com.au,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com> <df9815e70802132102v7eb7d8e9k4d6b21ffa6325d0d@mail.gmail.com>
In-Reply-To: <df9815e70802132102v7eb7d8e9k4d6b21ffa6325d0d@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> On 2/8/08, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> Hi Rusty,
>>
>> I was hopping you could answer a couple of questions about module loading/unloading
>> and the stop machine.
> 
> I'm curious to know why it is called `stop machine', which is a queer
> name without any relationship with its function.

I guess it's "stop the rest of the machine" and run this.  Maybe it's
misnamed but stop_machine is kind of cool.  :-)

-- 
tejun
