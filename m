Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYFPQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYFPQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYFPQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:57:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:65019 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbYFPQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rABEWEMwMN6W+eNFmkk26suBGDxFYuNUeyxgf5AvnRvYaRwfCtbP7K7xWsg5NRa7jb
         JTi85rXl9yCdYyvTvyBKE2unj+DpvuSs6cgsA/ObnB/HDAKZWZSHKdwLuuwDAVJgQHir
         erYnTWabscqCFg95hLApcrCEKLWM+ROpEOdjs=
Message-ID: <dd18b0c30806160957s20dfb513h1834dd1f9c3ecd5b@mail.gmail.com>
Date: Mon, 16 Jun 2008 16:57:07 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: audio: hda_intel azx_get_response timeout
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h63s9pbxe.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806151043k46200e22lcaae79ad1f8209ed@mail.gmail.com>
	 <s5h63s9pbxe.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 4:44 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sun, 15 Jun 2008 17:43:01 +0000,
> Justin Mattock wrote:
>>
>> I've noticed this([   14.630815] hda_intel: azx_get_response timeout,
>> switching to polling mode: last cmd=0x00bf1c00
>>  with 2.6.26-rc2 or 3, when connecting external speakers to listen to
>> music(keep in mind this was only once),
>> Now with kernel 2.6.26-rc5 and 6 I'm seeing this pop up every so
>> often,(seen this three times now). attached is dmesg of the message.
>> If I see anything else I'll send a post.
>
> Well, this is no fatal error but a warning, but of course better
> without it.
>
> It might be related with the position that runs.  I see the clock
> source tsc unstable message right after it, so the timeout check could
> be unreliable...
>
>
> Takashi
>

Hmmm, Well, whenever this goes off, if and when it decides, I'm not
hearing anything different
with the sound. Seems like a minor issue nothing to intense.
regards;

-- 
Justin P. Mattock
