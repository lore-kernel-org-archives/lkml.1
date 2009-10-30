Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZJ3GZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZJ3GZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 02:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZJ3GZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 02:25:19 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41681 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbZJ3GZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 02:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TG+AIpKhVQyO1Wd9lYD1Ofr/7kdH1DvNz65m0j5lUH1rBY7gBgdlcWqOAdQypG6RNE
         hpBVJMbvn5RkPayIpKM2UQHPAgIZz+VO/a6gO/c623Hm2NPBNFlVf9UCTJB94GBLaQmM
         dYYtE2r4f1cj4wbeCbaUPSeA2FhzqDDCbRDOE=
MIME-Version: 1.0
In-Reply-To: <cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	 <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	 <20091005092148.4341d9ab@jbarnes-g45>
	 <cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	 <20091029094723.7e5a3376@jbarnes-g45>
	 <cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	 <cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
Date: Fri, 30 Oct 2009 02:25:21 -0400
X-Google-Sender-Auth: 502e93f72d44fb92
Message-ID: <cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
Subject: Re: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 1:40 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> I just suspended and resumed and power consumption stayed low.  I'll
> try and get an intel_reg_dumper diff next time I trigger this bug.

intel_reg_dumper blames RENCLK_GATE_D2.  Patch coming.

Maybe my BIOS doesn't always reset it.

--Andy

>
> --Andy
>
