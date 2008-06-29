Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbYF2EmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbYF2EmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 00:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYF2EmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 00:42:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:22611 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYF2EmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 00:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xMoXPRv9VgiMVgLYjltutEXVju+FIB9yEBa9kx7By1mAHogKkUt0XDrH3lJvKpZuhf
         Tje2W5DwaebkSXQcX3WDZ1sHOxhCP4sODzTRBm1wbnxx63J5adUO9ranGXm6RAZSegf7
         X2+ByQOrQpltpP2BDKck3a02012b4kp0e0Uko=
Message-ID: <86802c440806282142n6a4e9a2fj89caaddaad8e6201@mail.gmail.com>
Date: Sat, 28 Jun 2008 21:42:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: early res print out alignment v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080628063626.GB15710@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <200806252151.29028.yhlu.kernel@gmail.com>
	 <200806262317.48716.yhlu.kernel@gmail.com>
	 <200806271536.54351.yhlu.kernel@gmail.com>
	 <20080628063626.GB15710@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 11:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> v2: fix print info to cont
>
> applied to tip/x86/unify-setup.
>
>>     [ - ] change to xxx - xxx
>
> hm, i changed this back to "[ xxx - yyy ]" - i think it's slightly more
> structured hence more readable.

should change [ xxx - yyy ] to [xxx - yyy]
otherwise print out width is bigger than 80

YH
