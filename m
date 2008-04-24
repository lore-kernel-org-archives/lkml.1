Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYDXUxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYDXUxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYDXUxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:53:11 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:51499 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086AbYDXUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kQijb6oDmzF4NJzp7G7p367lm7V6V/+M1cuQ/dK9uidLghs8IwYINBGlY/Bl/MV6FreoOPCYYA4+uH+EOMKhDfDeUxFKwKJVYd8+ExApEoEUJJuJUzOIQTlysVn678GbL2sYLXOM5IabH28pS8ndUupQ8TWw9Xbhz1WHRPofzOA=
Message-ID: <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
Date: Thu, 24 Apr 2008 13:52:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "James Cloos" <cloos@jhcloos.com>
Subject: Re: Regression: starting X locks box with git master
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 12:59 PM, James Cloos <cloos@jhcloos.com> wrote:
> 3dc5063786b273f1aee545844f6bd4e9651ebffe was current when I compiled.
>
>  With that kernel, my laptop locks up as soon as I startx.
>
>  The Xorg.0.log showed that the radeon driver got as far as starting
>  the i2c calls to the M7 video card.
>
>  After that the box would reply to ICMP pings and SysRq-B, but was
>  otherwise non-responsive.  Even SysRq-[KSU] seemed to do nothing.
>
>  v2.6.25 works fine.
>
>  There are 3562 commits (including merges) between those two, and
>  it takes an hour or more for each kernel compile.  Bisecting will
>  be quite painful.  And I only have the one box to work on.  But I
>  will see what I can do.
>
>  Posting before bisecting in case it helps anyone else....

Do you have CONFIG_X86_PAT in your .config?

YH
