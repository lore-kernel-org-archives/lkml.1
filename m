Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYKGIGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYKGIGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYKGIF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:05:58 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:59299 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYKGIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uIKVewYt66f098ghakhZ+EJByrG7AfRnsjd8CVBTwQ5x4AXANWbC3m17t8Xy9CxIig
         fA99iGwEJm0LFw2iaVK3mR6kUePavX183Euwv9YTh5a9pAFNlD97knk21nBTQrpC9KGd
         HdsIVGlvzhHLDRAEtYClDOXC7q1qmF0mizIyg=
Message-ID: <8bd0f97a0811070005r6a9fb1e1s9fd88bd264ef8ae2@mail.gmail.com>
Date: Fri, 7 Nov 2008 03:05:56 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Cc: alsa-devel@alsa-project.org, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5h7i7gq7xz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
	 <s5hod0sqcmt.wl%tiwai@suse.de>
	 <8bd0f97a0811062309m4029f612k4d3fe380e6d124df@mail.gmail.com>
	 <s5hk5bgqa61.wl%tiwai@suse.de>
	 <8bd0f97a0811062329l26f8338ahbb62bab9e8284c36@mail.gmail.com>
	 <s5hbpwsq92z.wl%tiwai@suse.de>
	 <8bd0f97a0811062357y52ff0107yee74c0a2ff010019@mail.gmail.com>
	 <s5h7i7gq7xz.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 03:03, Takashi Iwai wrote:
> At Fri, 7 Nov 2008 02:57:40 -0500, Mike Frysinger wrote:
>> On Fri, Nov 7, 2008 at 02:38, Takashi Iwai wrote:
>> > At Fri, 7 Nov 2008 02:29:25 -0500, Mike Frysinger wrote:
>> >> it also breaks
>> >> valid C code if there were side effects in the (cond) as any other
>> >> macro which does not properly utilize every argument exactly once.
>> >
>> > BTW, what do you mean this exactly?
>>
>> any potent statement.  such as assignment or pre/post increment/decrement or ...
>
> Well, in that case, such a code itself is buggy :)

i'm not advocating doing this sort of thing, i'm saying that
functions/macros should be written correctly so as to not break
standard C behavior.  a guy developing a codec driver could waste a
lot of time because of this sort of thing.
-mike
