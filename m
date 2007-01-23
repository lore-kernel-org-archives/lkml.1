Return-Path: <linux-kernel-owner+w=401wt.eu-S964827AbXAWMmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbXAWMmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964830AbXAWMmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:42:21 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:13602 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827AbXAWMmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:42:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=itAd6wrthazst194dClknD0FBrSs8scf9PGWOKXx0bB5d+UtdR2d0O4nekhyMa8sYpR6FH/WieOMfqG6KzlEimqUegvDMnlCy75JPh83BfwVmIKrTmFZJ5e8zqpgWyrHc7wo7324s1FzJ7uGyXS72LwMYr/f81Lc7i2B63dsR3A=
Message-ID: <1defaf580701230442p3f0d6b66ue7d67a88abf5a66a@mail.gmail.com>
Date: Tue, 23 Jan 2007 13:42:19 +0100
From: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 04/12] clocksource: avr32 initialize list value
Cc: linux-kernel@vger.kernel.org, "Haavard Skinnemoen" <hskinnemoen@atmel.com>
In-Reply-To: <20070123055345.727247649@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070123055255.338254780@mvista.com>
	 <20070123055345.727247649@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Daniel Walker <dwalker@mvista.com> wrote:
> Update arch/avre32/ with list initialization.
>
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>

Looks good to me, although I suppose it wouldn't hurt to include
<linux/list.h> as well since there seems to be an ongoing effort to
reduce the number of files that are included implicitly through other
headers. Might save us from some trouble later.

I've closed your support request, so you shouldn't expect a reply from
avr32@atmel.com (I was going to reply through the support system, but
I couldn't figure out how to prevent it from top-quoting.) Probably
best if you send patches directly to me at hskinnemoen@atmel.com, but
the support address is a nice fallback if I'm unable to respond for
some reason.

Haavard
