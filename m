Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZH0OUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZH0OUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZH0OUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:20:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:35414 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZH0OUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:20:14 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Aug 2009 07:20:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090827080647.GA7460@redhat.com>
Message-ID: <alpine.DEB.2.00.0908270718510.3809@makko.or.mcafeemobile.com>
References: <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com> <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com> <4A9585EC.2030505@redhat.com>
 <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <4A95900D.9090201@redhat.com> <alpine.DEB.2.00.0908261242530.7780@makko.or.mcafeemobile.com> <alpine.DEB.2.00.0908261626410.7780@makko.or.mcafeemobile.com> <4A9607EC.2080304@redhat.com>
 <20090827080647.GA7460@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Michael S. Tsirkin wrote:

> On Thu, Aug 27, 2009 at 07:13:32AM +0300, Avi Kivity wrote:
> > On 08/27/2009 02:30 AM, Davide Libenzi wrote:
> >> On Wed, 26 Aug 2009, Davide Libenzi wrote:
> >>
> >>    
> >>>> I see no kernel equivalent to read(), but that's easily done.
> >>>>        
> >>> Adding an in-kernel read based on "ctx", that is no problem at all.
> >>>      
> >> Something like the untested below.
> >> I had thought you said the eventfd readers where in userspace, but I might
> >> have misunderstood you.
> >>    
> >
> > No, they're all over the place.
> 
> Further, with Davide's proposal you must be a reader to signal events.

To signal events, you must have an instance of "ctx" (with the new 
exposed eventfd_ctx_read). How would you do otherwise?


- Davide


