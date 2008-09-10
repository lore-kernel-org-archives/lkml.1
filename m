Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYIJNK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYIJNK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYIJNKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:10:14 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:47865 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYIJNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V2whn8AdAUItWmfad6Nm5gTy9vSp0l5PKiLLeN2erjCQBeklLgUiJlFcjkXpB2XtHZ
         ZPEcoKmoEtxIQ63qG3zFj31zmF5Ue9/Yv4Al/uZFEsTmrrnQW025IPFyDx4v1pM3H6mm
         AG0K4OntACpJpdgCZAxHu4gOSau8rO/svGfzg=
Date: Wed, 10 Sep 2008 17:11:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <caulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
	__u* typedef
Message-ID: <20080910131158.GB3468@x200.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <1221045726-5674-2-git-send-email-kirill@shutemov.name> <20080910121450.GA3468@x200.localdomain> <20080910125503.GG3757@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910125503.GG3757@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 03:55:04PM +0300, Kirill A. Shutemov wrote:
> On Wed, Sep 10, 2008 at 04:14:50PM +0400, Alexey Dobriyan wrote:
> > On Wed, Sep 10, 2008 at 02:22:04PM +0300, Kirill A. Shutemov wrote:
> > > --- a/include/linux/dlm_plock.h
> > > +++ b/include/linux/dlm_plock.h
> > 
> > > +#include <linux/types.h>
> > 
> > I'd say that unless you can demonstrate compilation breakage, these will
> > only slow down compilation.
> 
> Do you think that minor slow down is worse than dependence on the order of
> inclusion?

Since it compiles fine there is no such dependency.

Just removing externs from function prototypes makes compiles go faster for
_seconds_.
