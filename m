Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbXIBTrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbXIBTrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXIBTrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:47:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:4494 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXIBTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BCtzBieppoC49Ut/RI/aS3gyffClCcRUYImM68AgidDwIjjHLWGlYGWMipmZ3jZdtdKp29Ncpa2DWGDW31vNaBVWQSO6bp2rOtIWvIrJOAq/c0SZNOvMwle6qVsGz7M8MyXtiDIpveBLhpoxPAnaz9RFEcMhpOYTkQdXZNrRAMo=
Message-ID: <71a0d6ff0709021247uefb4695y13a24523900e1b91@mail.gmail.com>
Date: Sun, 2 Sep 2007 23:47:12 +0400
From: "Alexander Shishkin" <alexander.shishckin@gmail.com>
To: "Philippe De Muyter" <phdm@macqel.be>
Subject: Re: Hint needed : how to debug sempahore's problem
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
In-Reply-To: <20070902194031.GA24800@ingate.macqel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070713102610.GA16087@muff.macqel.be>
	 <20070902194031.GA24800@ingate.macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Philippe De Muyter <phdm@macqel.be> wrote:
> Hi all,
Hi,

> Can someone give me some hint or link for the following question :
>
> I have several processes blocked in 'D' state, and I surmise they are
> waiting for a semaphore (in the `down' routine).  How is it possible :
> - to verify the processes are really blocked on a semaphore,
> - to see which semaphore they are waiting on,
> - to find out which process/driver/whatever holds those semaphores.
I'm sure there might be a better solution, but the easiest one I've
found for myself is enabling sysrq and sending sysrq-p or sysrq-t
combination to the board's console and see the callpaths that lead to
a deadlock (or other incorrect locking situation) in the kernel.

-- 
I like long walks, especially when they are taken by people who annoy me.
