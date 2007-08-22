Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXHVQrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXHVQrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762291AbXHVQrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:47:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:19591 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763493AbXHVQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XQP5/oKGCVSVv37C0ZOaKEPF1f2eoiGFPCWbUnG/zIWihIC1wO0B8FxrfzkJNhSNWorh9ONKXbsaUfHSIcW7+uK/1c+TNhxylzRPn8fHjmRmX0AkEv+RrZav3Uc28cXlgHS71mifFRbGTwODscrUyuAr+47FM9ZxKCmSWjroR8w=
Message-ID: <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com>
Date: Wed, 22 Aug 2007 18:46:58 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Cc: "Stephen Smalley" <sds@tycho.nsa.gov>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822083844.%N@1wt.eu>
	 <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
	 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
	 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
	 <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/07, James Morris <jmorris@namei.org> wrote:
> On Wed, 22 Aug 2007, Michal Piotrowski wrote:
>
> > On 22/08/07, James Morris <jmorris@namei.org> wrote:
> > > On Wed, 22 Aug 2007, Stephen Smalley wrote:
> > >
> > > > Oops, never mind - tail still follows secmark, so that shouldn't matter.
> > > > So I'm not sure why we are getting a bad value for secmark here - should
> > > > be initialized to zero and never modified unless there is an iptables
> > > > secmark rule.
> > >
> > > Michal, do you see this in current git?
> >
> > No, I do not see this problem in 2.6.23. I had similar problem last
> > month, but it is fixed now.
> >
> > http://lkml.org/lkml/2007/7/12/362
>
> The previous problem is theoretically unrelated.  It arose via a separate
> mechanism which can't be used at the same as the one you're seeing now in
> the logs.
>
> So this either looks like a problem which has gone unnoticed and was
> inadvertently fixed at some point, or is unique to the 2.6.20 stable
> series.

Yup, it is very interesting why no one noticed it. Binary search in progress:
good - 2.6.20.4
bad - 2.6.20.8

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
