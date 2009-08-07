Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZHGMHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZHGMHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZHGMHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:07:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56378 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZHGMHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TuETigvbvJ4kpckuoBaYROPu18TqLHjjmEFv2KrtLuA5OEztC3+XCvvZ7TmNuytfZ0
         3XfJC74eRNUs1z+TIOpHou1GUX+aaTUdHU/SwyPMNOotzfUpFSRC+dhXvDslbd0Z075h
         SyG0Qz//SZ1n/Mp8+8+fN6LJatpajzjhseKvE=
MIME-Version: 1.0
In-Reply-To: <20090807095426.GI8725@shareable.org>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
	 <20090806222543.GG31579@n2100.arm.linux.org.uk>
	 <1249624766.32621.61.camel@david-laptop>
	 <200908070958.31322.laurent.pinchart@ideasonboard.com>
	 <20090807081041.GB18343@n2100.arm.linux.org.uk>
	 <20090807095426.GI8725@shareable.org>
Date: Fri, 7 Aug 2009 14:07:43 +0200
Message-ID: <761ea48b0908070507n5c580455pb86e5240a7cf6c0c@mail.gmail.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is 
	get_user_pages() enough to prevent pages from being swapped out ?")
From: Laurent Desnogues <laurent.desnogues@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       David Xiao <dxiao@broadcom.com>, Ben Dooks <ben-linux@fluff.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Robin Holt <holt@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       v4l2_linux <linux-media@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 11:54 AM, Jamie Lokier<jamie@shareable.org> wrote:
>
> 1. Does the architecture not prevent speculative instruction
> prefetches from crossing a page boundary?  It would be handy under the
> circumstances.

There's no such restriction in ARMv7 architecture.


Laurent
