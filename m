Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbZEYFjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbZEYFjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZEYFj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:39:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34896 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZEYFj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:39:28 -0400
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable
 before using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A1A2ADC.1090004@redhat.com>
References: <1242793775.3260.2.camel@localhost.localdomain>
	 <4A193BCE.90307@redhat.com> <1243228626.3157.4.camel@localhost.localdomain>
	 <4A1A2ADC.1090004@redhat.com>
Content-Type: text/plain
Date: Mon, 25 May 2009 11:07:32 +0530
Message-Id: <1243229852.3157.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 08:21 +0300, Avi Kivity wrote:
> Jaswinder Singh Rajput wrote:
> >> It's a false alarm.  Isn't there a macro to shut up the warning?
> >>
> >>     
> >
> > In arch/x86/kvm/paging_tmpl.h sptep is initialize only in :
> >
> > for_each_shadow_entry(vcpu, addr, iterator) {
> >
> > If we skip this, then we end up with wild sptep and returning it.
> >
> > Do you still think it is a false alarm ?
> >   
> 
> That loop always has at least one iteration.
> 

hmm, In that case we should use a do-while flavor function so that the
compiler will also happy with it.

--
JSR

