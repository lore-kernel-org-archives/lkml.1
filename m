Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbXFZBss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbXFZBss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXFZBsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 21:48:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:58389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXFZBsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 21:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=ccehEeLYlU0QQCybXAUpVOGG6qyicqWhNdGM7YIzykbKfM3LeNWcjlj9TMm8n9StVl5Sh/623cLbVXeOF/O4rH7D7QAo30j3KRCaQhdvTuJSrfVWVEYWVJO53os0hNFHSaxsV+kPvqAIZ98i1LVnlIonXe6+qOfHlwre/TtN4yA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Limiting load of certain processes
Date: Tue, 26 Jun 2007 04:44:35 +0300
User-Agent: KMail/1.9.4
Cc: Jan Kandziora <jjj@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706211950.40825.jjj@gmx.de> <200706212100.28381.jjj@gmx.de> <Pine.LNX.4.64.0706212110440.26568@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706212110440.26568@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706260444.35818.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007 22:11, Jan Engelhardt wrote:
> On Jun 21 2007 21:00, Jan Kandziora wrote:
> >I know it's a crude idea for everyday Linux processes, but for
> >dosemu driven applications, which behave badly in a multitasking OS
> >*and* for which source code isn't available, it may be worth to
> >discuss.
>
> Would dosbox do? (it does busy-loops too, but at least, it's got
> source)
>
>
> 	Jan

Hi.

Try  to set $_hogthreshold = (1) in dosemu.conf

This helps a lot for me.

Regards,
	Maxim Levitsky
