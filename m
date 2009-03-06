Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZCFPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZCFPP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZCFPPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:15:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:55884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZCFPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:15:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k28g/MBH7p4+lfVoVaJKIazBQIQt1mwn2RvA0oaIJ4JeaWeJVfrQm8MiXojUf2avVp
         wTbzWGpnyt8UvyO4Ij6RN9sfrj0rjo5wBGexp2NzFrwnpKrtq67AhTFwbAAVwql47slw
         Qf/2jDCw8PFXSzsokqGtDSgHcYC6dpCgUVOm0=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090305161837.6ba80cc1@infradead.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
	 <1236004353.10055.49.camel@andreas-laptop>
	 <20090302082003.1bb7bdc5@infradead.org>
	 <ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	 <20090302102703.50aaf724@infradead.org>
	 <1236192430.6785.111.camel@andreas-laptop>
	 <20090305161837.6ba80cc1@infradead.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 16:15:43 +0100
Message-Id: <1236352543.6594.59.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 16:18 -0800, Arjan van de Ven wrote:
> On Wed, 04 Mar 2009 19:47:10 +0100
> Andreas Robinson <andr345@gmail.com> wrote:
> 
> the only thing I can say (the graphs are a bit complex to read) is that
> you are loading a LOT of very expensive modules that bring you no
> functionality.

Well, yes. It is the generic Ubuntu kernel booting in all its bloaty
glory. :) But this is what most users are stuck with. The distro vendors
won't change their ways because they want their stuff to run on
anything.

So I'm not trying to build a custom kernel just for me. I want to find
ways to have any distro optimize itself to boot in 5-10 seconds on any
computer it has been installed on, without manual configuration. 

> Also I'd love to have seen the scenario where the modules were just
> build into the kernel; that gives usually a more reliable indication of
> what is going on...

Alright, I'm on it.

Cheers,
Andreas


