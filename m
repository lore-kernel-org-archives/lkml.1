Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYJORu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYJORu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbYJORt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:49:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:15359 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYJORt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V5w7V32XW5lDZeaF/21yKucrk8ajSkf+tMO5kzRbBnRmy4nxL2OMupdFdg6vGTygoK
         r2sPtFhX8Uw2jtL9MKg1ugMmOlRAuiSh2O8neGQ6aehfZWGwV8GGAo0nWFH7M8opevTR
         xvKfTeBX6eG6J/g4AAVtHQbUdIc2G/atK6CbY=
Date: Wed, 15 Oct 2008 21:52:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
	mechanism
Message-ID: <20081015175252.GA10600@x200.localdomain>
References: <20081012194427.2e21c22e@infradead.org> <20081015014117.faff3a61.akpm@linux-foundation.org> <20081015075246.2e1610f3@infradead.org> <20081015095905.41219c9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015095905.41219c9d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 09:59:05AM -0700, Andrew Morton wrote:
> On Wed, 15 Oct 2008 07:52:46 -0400 Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Wed, 15 Oct 2008 01:41:17 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > +static int async_active = 0;
> > > 
> > > ?
> > ok will add comment
> 
> I was actually "?"ing at the "= 0".  I thought that would be obvious
> but it's whizzed past two people so far :(

Is there evidence that some gccs will not add such variable to .bss?

Because "= 0;" is more readable.
