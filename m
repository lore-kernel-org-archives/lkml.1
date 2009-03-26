Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZCZKMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZCZKMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZCZKM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:12:28 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:60242 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZCZKM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:12:27 -0400
Date: Thu, 26 Mar 2009 11:12:23 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Next March 26: s390 allnoconfig build failure still exists
Message-ID: <20090326111223.3a8ad942@osiris.boeblingen.de.ibm.com>
In-Reply-To: <49CB5165.4060401@in.ibm.com>
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
	<49CB5165.4060401@in.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 15:26:53 +0530
Sachin Sant <sachinp@in.ibm.com> wrote:

> I still see the following s390 allnoconfig build failure
> with today's next (and previous trees as well ).
> 
> arch/s390/include/asm/smp.h:96: error: redefinition of smp_send_stop
> include/linux/smp.h:125: error: previous definition of smp_send_stop was here

In theory it should have been fixed, since I sent a patch and Ingo applied it:

http://lkml.org/lkml/2009/3/20/74

For some reason it doesn't show up in linux-next.
