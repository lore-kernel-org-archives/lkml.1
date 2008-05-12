Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbYELHUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbYELHUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELHTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:19:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:58395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbYELHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=L3UBuKdj0GWFpbbIf6kfuKHn0Qs+HJy0P5m6FejvZQYE53ih7BJz6XWY3pDz74t9YbeLtMZHgk21GQMcyNl7TizPP0vc4nqYtBP8UIm2gVMHkhxGBeZ3KSI9/WGLLr3Jc1GtJVXmvocVGgCoeWG7RN27Kir+chzbraamkAPdl9c=
Message-ID: <4827EF80.7070404@gmail.com>
Date: Mon, 12 May 2008 09:19:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] HID: add compat support
References: <1210536043-19812-2-git-send-email-jirislaby@gmail.com> <1210536043-19812-3-git-send-email-jirislaby@gmail.com> <1210536043-19812-4-git-send-email-jirislaby@gmail.com> <1210536043-19812-5-git-send-email-jirislaby@gmail.com> <1210536043-19812-6-git-send-email-jirislaby@gmail.com> <1210536043-19812-7-git-send-email-jirislaby@gmail.com> <1210536043-19812-8-git-send-email-jirislaby@gmail.com> <1210536043-19812-9-git-send-email-jirislaby@gmail.com> <20080511204807.GB850@uranus.ravnborg.org> <48275FFC.9060305@gmail.com> <20080511211839.GA1641@uranus.ravnborg.org>
In-Reply-To: <20080511211839.GA1641@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2008 11:18 PM, Sam Ravnborg wrote:
> So what I try to say is that we should replace the above with
> a hid-dummy.h file that is handedited.

Ah, yes, I got it now. I mulled over that, we're talking about 15 or so drivers 
and it's pretty ugly. I'll drop hid-dummy.h file generation, since it will be no 
longer needed.

> We could stick a few comments in the .h file explaining the usage too.

I think it's not worth it. It's just for 2, 3 kernel releases and then we will
say it goodbye.

Thanks.

