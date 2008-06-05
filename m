Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYFETRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYFETRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYFETRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:17:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36258 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYFETRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:17:03 -0400
Date: Thu, 5 Jun 2008 14:16:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] devscgroup: make white list more compact in some
	cases
Message-ID: <20080605191647.GA27304@us.ibm.com>
References: <4847A7BE.5010603@openvz.org> <20080605142338.GB11919@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605142338.GB11919@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Pavel Emelyanov (xemul@openvz.org):
> > Consider you added a 'c foo:bar r' permission to some cgroup and then
> > (a bit later) 'c'foo:bar w' for it. After this you'll see a
> > c foo:bar r
> > c foo:bar w
> > lines in a devices.list file.
> > 
> > Another example - consider you added 10 'c foo:bar r' permissions to
> > some cgroup (e.g. by mistake). After this you'll see 10
> > c foo:bar r
> > lines in a list file.
> > 
> > This is weird. This situation also has one more annoying consequence. 
> > Having many items in a white list makes permissions checking slower, 
> > sine it has to walk a longer list.
> > 
> > The proposal is to merge permissions for items, that correspond to the
> > same device.
> > 
> > Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 
> Thanks.  I suppose if it was deemed worth it, the other thing you could
> do would be to detect when you have a rule
> 
> 	c foo:bar r
> 
> and you add a rule
> 
> 	c foo:(all) r

But a private email response preferred the each-entry-is-separate
semantics, so I retract that suggestion.

-serge
