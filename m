Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZHTRo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZHTRo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZHTRo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:44:27 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54204 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZHTRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:44:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Aug 2009 10:44:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Avi Kivity <avi@redhat.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <4A8D8A28.2050004@redhat.com>
Message-ID: <alpine.DEB.2.00.0908201042100.14844@makko.or.mcafeemobile.com>
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Avi Kivity wrote:

> On 08/20/2009 07:20 PM, Davide Libenzi wrote:
> > 
> > I briefly looked at this while in vacation, although I did not reply
> > hoping the horrible feeling about this code would go away.
> > It didn't.
> > I find this to be an ugly and ad-hoc multiplexing of eventfd with added
> > functionalities of questionable general use.
> > I'm pretty sure you can do better on KVM side, to solve the problem w/out
> > littering eventfd.
> > 
> >    
> 
> While we could argue about this my feeling is that we should drop this, at
> least until we can quantify what benefit it has and whether there are any
> Davide-acceptable alternatives.

I really didn't mean to be harsh, but seriously, we cannot just have a 
Multiplexing Feast over eventfd, with one-time users.


- Davide


