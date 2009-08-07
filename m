Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZHGL17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZHGL17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZHGL17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:27:59 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59128 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZHGL16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=XxV2Zn41giVYQdGxDPV1wJCLJYfKwpBY9RJV52VoJ2X8gi0B4RNxXkB5Is/U8Gm50x
         11HUAEicamavL5KXIz2BNsbdTU6i9Wbq9NwR+qRiffhB89OwdXkaz2CjDEcxr3zUgNIU
         0BrYMYq0lgGQJy3Rhk0SoWWTitBnAtNJKuIAU=
Message-ID: <4A7C0FB8.8040304@gmail.com>
Date: Fri, 07 Aug 2009 13:27:52 +0200
From: Henk Martijn <h.h.martijn@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       jpirko@redhat.com, eric.dumazet@gmail.com, davem@davemloft.net
Subject: Re: [bisected] boot speed regression in current git
References: <4A7BFCC4.8060006@gmail.com> <200908071254.20163.elendil@planet.nl>
In-Reply-To: <200908071254.20163.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
>> I bisected this to "net: restore the original spinlock to protect
>> unicast list" commit: a6ac65db2329e7685299666f5f7b6093c7b0f3a0
>> reverting this commit gives me back 20 s in boot time.
> 
> Try adding this patch from Ingo. It will probably fix the issue:
> http://marc.info/?l=linux-kernel&m=124945666109347&w=2
> 
> Cheers,
> FJP
> 
Jep, Ingo's patch fixed it. 

Thanks!

/Henk
