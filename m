Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYHBSD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYHBSD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYHBSDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:03:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:46219 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbYHBSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w/NL2V6STF7VBQsj/gh0qyN/HWjUQAII4zKTIEXdDj5ViMaryjPeV4cTPE53HP3QK7
         5fo98q/6/S1q1Yf4U1O/oMDSWtDBENOGbn/ECg1NIvkfASGjBOe5P2efn8yYNxtXaqaf
         ILgpYnm6Fg48pEW172LIipOZgLi4s44nMvL1Y=
Message-ID: <590657100808021103n1a825705m9af120b103ca7573@mail.gmail.com>
Date: Sat, 2 Aug 2008 11:03:49 -0700
From: "Harvey Harrison" <harvey.harrison@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: [PATCH 14/20] parisc: use the new byteorder headers
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Kyle McMartin" <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080801231807.GA26550@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216339783.6029.125.camel@brick>
	 <20080801160647.GA22049@colo.lackof.org>
	 <1217625817.5846.5.camel@brick>
	 <20080801231807.GA26550@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My reply yesterday didn't seem to make it out.

On Fri, Aug 1, 2008 at 4:18 PM, Grant Grundler
<grundler@parisc-linux.org> wrote:
> On Fri, Aug 01, 2008 at 02:23:37PM -0700, Harvey Harrison wrote:
>> Other than the endianness, any other concerns?
>
> Have you had a chance to test this?

le-only personally (X86-32).

> Or can you point me at another big endian arch that has similar
> use of header files that has been successfully tested?
>

AVR32 got a maintainer ack, I'm assuming that was tested.  It's not
functionally any different than the existing code really, other
than allowing compile-time folding in the cpu_to_{endian} helpers.

Mips was also acked, but that can be little or big endian.

> I can arrange for access to parisc HW if you have time/interest
> in testing this yourself.
>

Sure, drop me a note.

I'll have intermittant connection for the next week, so there might be
a few days before I can reply.

Harvey
