Return-Path: <linux-kernel-owner+w=401wt.eu-S935779AbXHHOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935779AbXHHOyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935713AbXHHOx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:53:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:17779 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935652AbXHHOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s/mq0HPZpOneXuiflcZWUR57CvOWbGS0zz01QbtPdkOHLbEpOg4noDoYf0KddKEjYZHy4rFtV5Fxm5MnKqFa/CV/gGGmMLLEt/wriSGLaxyzwIGCd5RBIEbPEl9xeAVnhAcnz/iuuJHVnkIMuQn9prhthPFZ/6/WlBPzOWh8fJc=
Message-ID: <5d6222a80708080753l30348fbarb214eba1f94a63d0@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:53:53 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, anthony@codemonkey.ws, akpm@linux-foundation.org,
       mingo@elte.hu
In-Reply-To: <200708081611.25152.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <200708081138.23018.ak@suse.de>
	 <5d6222a80708080658j780667c4o52e924f8690f2a85@mail.gmail.com>
	 <200708081611.25152.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> > > Similar.
> > I don't think so. They are live here, but restore_args follows, so we
> > can safely clobber anything here. Right?
>
> The non argument registers cannot be clobbered.
But they are not. Yeah, I ommited it in the changelog, (it is in a
comment at paravirt.h), should probably include. the CLBR_ defines
only accounts for the caller-saved registers.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
