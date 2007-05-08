Return-Path: <linux-kernel-owner+w=401wt.eu-S1032435AbXEHWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032435AbXEHWAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032087AbXEHWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:00:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:53448 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032082AbXEHWA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lDGTxQI7UV3YZLIT1CBYRcJqK77GVtt+xmbMcTrjk5fk8tqqK2xdiT2UzbcTk15YMl6jO184mOo2cFuBxyAN9zvuqLw34AX9BcEL7Xu4kadnHmbbIZwA5MrHVaEXjjmTM5hhoxaVR9IbuUhja2jXph5se4s48dsBIRdCTvFAXeU=
Message-ID: <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
Date: Tue, 8 May 2007 15:00:26 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <m1k5vji107.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org> <46390523.5010809@goop.org>
	 <463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> You might try a git-bisect, or if it is just these patches
> walking through them one-by-one.

f82af20e1a028e16b9bb11da081fa1148d40fa6a is first bad commit
commit f82af20e1a028e16b9bb11da081fa1148d40fa6a
Author: Gerd Hoffmann <kraxel@suse.de>
Date:   Wed May 2 19:27:19 2007 +0200

    [PATCH] x86-64: ignore vgacon if hardware not present

    Avoid trying to set up vgacon if there's no vga hardware present.

    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Cc: Alan <alan@lxorguk.ukuu.org.uk>
    Acked-by: Ingo Molnar <mingo@elte.hu>

YH
