Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZFDJUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZFDJUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZFDJU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:20:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:44184 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZFDJU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=px2t6mgvzibY6caQzHeheXtwRlBFMYdAFzmUpB6IbuRv2JEoA4jkWf+E5p+mQE9P8I
         bBSaTRH8cBP7wMyKtxzi8Dckl2YCCv9DWLtK1wbfE2SxoTVENbZFc1A8N+7DxxcpU1Ag
         sbGWGSLfFq/MHGsaU1+ex3gX/EETypKNkv280=
MIME-Version: 1.0
In-Reply-To: <200906040215.48264.david-b@pacbell.net>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	 <200906040206.44144.david-b@pacbell.net>
	 <8bd0f97a0906040209r269fe700hffd0cdcba264ca0b@mail.gmail.com>
	 <200906040215.48264.david-b@pacbell.net>
Date: Thu, 4 Jun 2009 05:20:30 -0400
Message-ID: <8bd0f97a0906040220k6f56b944n733a2b3469faaccb@mail.gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
From: Mike Frysinger <vapier.adi@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 05:15, David Brownell wrote:
> On Thursday 04 June 2009, Mike Frysinger wrote:
>> the point was to lower the number of user<->kernel transitions.  yes,
>> all of this stuff can of course be done in the shell, but it's hard to
>> push limits when the interface is tying your hands and sitting on your
>> back.
>
> So what's the application that needs to do all this in
> userspace yet which can't hook up a quick kernel driver?
>
> I don't like the idea of embedding any kind of interpreter
> in the sysfs interface, but that's the direction you seem
> to be heading ...

i dont view the userspace GPIO interface as a simple "i want to wiggle
pins for fun and testing".  i see it as a dynamic method for building
userspace drivers for simple devices.  as such, having a very simple
"command language" for optimizing the interaction provides a pretty
good trade off between kernel complexity and lowering overhead imo.
-mike
