Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbZLGBdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbZLGBdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbZLGBdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:33:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51901 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZLGBdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y6bl8aodLYyTVrKhOZgJbDEJ5I3hZ7BSh84a9JH/Mn8W0jgEAB3WtN0mczQmEDG8z7
         59YgExDRfAnG9KLvGG9BQqJLwAp3toD2GIf/+1k69C+i2aiuKAoniVYhc9Y5TGdX6SA3
         8XNM/MBHhjAEhD5Ouan4b3M4anMFJ2XVUefcw=
Date: Mon, 7 Dec 2009 02:33:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] perf: Make location of kernel source configurable
Message-ID: <20091207013339.GC4966@nowhere>
References: <20091206307.542816612@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206307.542816612@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 03:07:30PM +0100, Andi Kleen wrote:
> 
> tools/perf has no support for separate object directories
> and lots of hard coded paths assuming that the kernel source
> is always in ../..
> 
> As a first step of compiling it separately without messing
> up clean source trees allow to configure the kernel source
> location using a KERNELSRC variable 
> 
> This allows at least to copy the whole tools/perf
> directory elsewhere and build it separately.
> 
> The default is still ../.., so for a standard build
> nothing changes
> 
> This also removes a lot of ugly ../.. from the source.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


It worry about that too.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

