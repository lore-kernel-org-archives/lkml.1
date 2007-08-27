Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbXH0IMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbXH0IMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXH0IL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:11:57 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:7304 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXH0IL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D7YHfMlEk97VVlEfFslrHA7kZbaazhULiJngaXv5BJ9x1yaE2d5uW1heT7CSSirf8Td/lfLfUl0XChoagVit2in/FKn7nU1Oc8y6AJhVjrzbqGpuAVKVQwUjX+yQvNBcmVFwduS1dZlgNR3ISptse+Dvh6qvdKlcKm9wheDSXmo=
Message-ID: <72dbd3150708270111h7845b5eam2b1d6279a0e33900@mail.gmail.com>
Date: Mon, 27 Aug 2007 01:11:55 -0700
From: "David Rees" <drees76@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "Daniel Walker" <dwalker@mvista.com>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <46D21E8E.4000003@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Bugzilla sucks when it comes to tracking things. There is
> a regression field, but there are no difference between
> 2.6.22 and 2.6.23 regression.

Here's how to use Bugzilla to track regressions between different
kernel versions:

Create a 2.6.22 regression bug and a 2.6.23 regression bug. All
regression bugs which are 2.6.22 regression bugs should block the
2.6.22 regression bug. All regression bugs which are 2.6.23 regression
bugs should block the 2.6.23 regression bug.

For example, say your master 2.6.22 regression bug tracking bug is #1.
When someone comes and files a new bug #2 which is a regression of
2.6.22, make bug #2 block bug #1. Then it is easy to see to track all
the 2.6.22 regressions.

To make it easier to remember what bug number tracks regressions for a
specific kernel, use a naming convention to create aliases for those
bugs.

-Dave
