Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYHVBz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYHVBz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYHVBzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:55:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39816 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYHVBzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:55:18 -0400
Date: Fri, 22 Aug 2008 03:57:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Move sysctl check into debugging section and don't make it default y
Message-ID: <20080822015718.GC23334@one.firstfloor.org>
References: <1218865985-23403-1-git-send-email-andi@firstfloor.org> <m1myj63neb.fsf@frodo.ebiederm.org> <20080821064009.GB18831@one.firstfloor.org> <m163pus08m.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163pus08m.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 11:15:37AM -0700, Eric W. Biederman wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> >> What is a feature change like this doing coming in after the
> >> merge window?
> >
> > I considered it a "anti bloat bugfix". Adding 30k of 
> > object code to allno was a bit too much. 
> 
> 30k???  Which platform are you testing on ia64????
> 
> On x86_64 it is 8k text and 8k data.

x86-64 with 4.1. See the size output in the original commit.

  text    data     bss     dec     hex filename
  36243       0       0   36243    8d93 kernel/sysctl_check.o

36k actually.

-Andi
