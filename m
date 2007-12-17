Return-Path: <linux-kernel-owner+w=401wt.eu-S934131AbXLQBxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbXLQBxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbXLQBxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:53:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:1875 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXLQBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:53:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=NdzvQT2QdKGDOjomXRhKXKV6ASspJskIBmQY9BFzh+wamrf/Z4i8NDq2CiQTkS85GSrbya3IGeROQDpQqnfaYp2uC6RKF7Cg3sk+NxkbECFpCCHj1hJ+on4wkzJeDroBQVaI8UVEesuAwkIOdHSjuLsqrASWXpzmP0RIY6aT9AQ=
Message-ID: <4765D62A.8020404@keyaccess.nl>
Date: Mon, 17 Dec 2007 02:51:38 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com> <20071216094029.GD27280@elte.hu> <47659BF3.4040100@zytor.com>
In-Reply-To: <47659BF3.4040100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-12-07 22:43, H. Peter Anvin wrote:

> Again, 24 is "right out".  25 is a "maybe", IMO.  Rene's fix could be an 
> exception, since it is a DMI-keyed workaround for a specific machine and 
> doesn't change behaviour in general.

I've not much opinion on the schedule as I've not the problem but yes, it's 
intended as the low risk option.

Rene.
