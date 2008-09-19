Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYISUkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYISUkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYISUkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:40:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:5109 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYISUkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mi2ilYN7+IviBQ3wZ/9PtBK+VFefDp5OuAqWpYneCiKGP8Wrhmcqe4zHDfChmiprff
         ezwn2Qf7m7UAd3X1IJ8CjC77gtKzFnkjLhwHZZvDBFs5qj1PMq2b2xKLW/vshqW+Gtlg
         KhgcR/Qlqq5aguZH3tIXVEFVjfPMQGpr6+d9E=
Message-ID: <86802c440809191340t75104d48g1f5cf5cf0e55035a@mail.gmail.com>
Date: Fri, 19 Sep 2008 13:40:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Dean Nelson" <dcn@sgi.com>
Subject: Re: [PATCH 1/3] switch vector_irq[] from irq number to irq_desc pointer v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Jack Steiner" <steiner@sgi.com>,
       "Alan Mayer" <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <Yinghai.lu@amd.com>
In-Reply-To: <20080919200449.GB6528@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919200212.GA6528@sgi.com> <20080919200449.GB6528@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 1:04 PM, Dean Nelson <dcn@sgi.com> wrote:
> Change per_cpu variable vector_irq[] from holding an 'int' irq number to
> holding a 'struct irq_desc' pointer.

why?

Eric wants to change int irq to some struct irq later?

YH
