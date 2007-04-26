Return-Path: <linux-kernel-owner+w=401wt.eu-S933753AbXDZJZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbXDZJZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbXDZJZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:25:34 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:58377 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808AbXDZJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B8i/XRc/GhoDBzCL7Dqw9G6iesHeVKeHKWsDmrrIOe5A8JiIBKNIwY4JhG7B3brgmEv4q4hkdqcD1rRIqAaLdE2Ay15CWa2TL+grLNtayynrhIo5q7RftvosltCoLWBBfT7M2+waaKtuGMUjrSAhk9zuFMPIH39/uVZuE2K27Mo=
Subject: Re: 2.6.21-rc7-mm1: Oops and Gnome desktop freezes
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dan Kruchinin <dubalom@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a8f16e2b0704252034t74a86f2em90f5f95176c3fde8@mail.gmail.com>
References: <1177512596.4856.17.camel@daplas>
	 <a8f16e2b0704252034t74a86f2em90f5f95176c3fde8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 17:23:43 +0800
Message-Id: <1177579423.4685.25.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 07:34 +0400, Dan Kruchinin wrote:
> Hi.
> 
> On 4/25/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
[snip]
> 
> I have just the same tracing, but my gnome desktop works pretty good
> until I launch some application which "eats" much mem, like evince or
> firefox. After it my X server automatically restarts .
> 

Reverting this fixed it for me:

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm1/broken-out/mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch

Tony

