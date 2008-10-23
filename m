Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYJWNmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYJWNmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYJWNk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:40:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:2232 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbYJWNk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NKefD5qDK13KMg+NlVEEpRzCJO4IbnF4GdQAkQiLZI2dm3HgMxTUgy0v3Z24mdqLr+
         Qd01XM0ChQP1sFCRx8JjkKXfR4Oo+jejSLrE8XfIClIGmR9afSJZHbH7n+s/FKUh/Rpa
         GfgcQtdWGkP6IlU9IgNPkZ1+tJxwa6E8O6y44=
Date: Thu, 23 Oct 2008 17:43:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] get rid if __cpuinit and __cpuexit
Message-ID: <20081023134339.GA29127@x200.localdomain>
References: <20081022153054.335ce51e@infradead.org> <20081023062143.GA2981@x200.localdomain> <20081023061719.3ae5b090@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023061719.3ae5b090@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 06:17:19AM -0700, Arjan van de Ven wrote:
> On Thu, 23 Oct 2008 10:21:43 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Wed, Oct 22, 2008 at 03:30:54PM -0700, Arjan van de Ven wrote:
> > > Subject: [PATCH] get rid if __cpuinit and __cpuexit
> > 
> > Aiee!
> > 
> > Was something said about __devinit/__devexit ?
> 
> one at a time ;-)
> 
> but seriously, I do want to look at that one too. But it's the last one
> on the list, the meminit ones come next as "obscure and complex"

__meminit is actually contorlled by memory hotplug which is off on most
people boxes, unlike __devinit which is controlled by CONFIG_HOTPLUG
which is on.

Suggest reassign priorities. :^)
