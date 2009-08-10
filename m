Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZHJQbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZHJQbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZHJQbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:31:23 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:43033 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbZHJQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XEfYX9+6f2x4kI5FJt/YMlG8cFPpGAzaQKa0LeDwwe+ZsZfFnVrqmYMICB4JWcyBrs
         VijvrzjSGDEDYzzevHdLfgXMnxX+uvDDSKonA9zPEwWd8FWz4ljTbbRK7U7K/wefQy9/
         Bhwa8DKHMU1PBY22w9heAnOULdCRmf04NrZ+E=
Date: Mon, 10 Aug 2009 11:26:24 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: "Emilio G. Cota" <cota@braap.org>, Greg K-H <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090810162624.GA25298@mediacenter>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A804283.5090009@gefanuc.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:53:39PM +0100, Martyn Welch wrote:
> Emilio G. Cota wrote:
>> Martyn Welch wrote:
>>   
>>> Emilio G. Cota wrote:
>>>     
>>>> - semaphores? isn't it screaming for mutexes?
>>>>       
>>> The semaphores are initialized in mutex mode.
>>>     
>>
>> I know, but then please use mutexes.
>>
>>   
> I'm clearly missing something here - can you provide me with an example?

The kernel now has native mutexes so there is no need to use semaphores
as mutexes.  Take a look at:

kernel/mutex.c

--
Shawn
