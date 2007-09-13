Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbXIMS1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbXIMS1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXIMS0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:26:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:41504 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbXIMS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UAutOQth4y7wiX5WkSQawFr7HMFsjCcAdQES2BH/b7JzGNQGlEPmEeiWNf2QFvDytpbzCVMteBf5JMdmHYxn3yHGOVJAXEMzik00uq3HHbliWUzA6MZFy6LkmbcTb0e9QmkUKv+9pdQok+NhM8PiZZ0ERPylByuHTgcW+K9yPDk=
Message-ID: <863e9df20709131126n182ec6f6l2c790bae4411d79e@mail.gmail.com>
Date: Thu, 13 Sep 2007 23:56:14 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Subject: Re: [PATCH 0/4] build system: section garbage collection for vmlinux
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200709112105.34301.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709112105.34301.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> Patches were run-tested on x86_64, and likely do not work on any other arch
> (need to add KEEP() to arch/*/kernel/vmlinux.lds.S for each arch).

This is good stuff. I had been using a ported variant of this
optimization for ARM on quite an older 2.6 kernel for a while now. I
derived that port from:
http://lkml.org/lkml/2006/6/4/169

With some tweaks it worked for me. Could you also have a look at the
mentioned link and see if that's a superset of what you're trying to
achieve?

--
Abhishek Sagar
