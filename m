Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbXKOW6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbXKOW6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765969AbXKOW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:58:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:24665 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765804AbXKOW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:58:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qZFfEsFjux8hJ0kly9ygfEw8Seo3/mLShcI50N7wBmhmcZt1/kidoGvUYzq2Cu/t21QM1KUQeH2vgaLt0mn+A92WqoCVjca/HnAaZ8Hia+RrIvigSjBxnz30ChCvKtODfb+yKEanLqw9+oaQSf1V6nDpfgQ+Qe/LlJg4r+VNR0o=
Message-ID: <e7d8f83e0711151458t3d4349d0k1b7ce4b030db87af@mail.gmail.com>
Date: Fri, 16 Nov 2007 08:58:36 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Crispin Cowan" <crispin@crispincowan.com>
Subject: Re: [Apparmor-dev] Re: AppArmor Security Goal
Cc: rmeijer@xs4all.nl, apparmor-dev@forge.novell.com,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <47395F00.6080507@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10657.80.126.27.205.1194933072.squirrel@webmail.xs4all.nl>
	 <47395F00.6080507@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > What is left unspecified here is 'how' a child 'with its own profile' is
> > confined here. Are it is confined to just its own profile, it may that
> > the "complicit process" communication may need to be wider specified to
> > include this.

Sorry have to bring this up.  cgroups why not?  Assign application to
a cgroup that contains there filesystem access permissions.   Done
right this could even be stacked.  Only give less access to
application unless LSM particularly overrides.

Comtainers allow overriding / in chroot style.  This needs file or
label based protection no matter the security framework.  So we don't
have the chroot problems of applications breaking out.

Apparmors file access control features along with selinux's as a
combined into a cgroup would be good.

Same is required for device control.

There are reasons why I keep on bring containers up it changes the
model.  Yes I know coming to a common agreement in these sections will
not be simple.   But at some point it has to be done.
