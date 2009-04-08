Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbZDHM41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbZDHM41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZDHM4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:56:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62539 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZDHM4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9dTU7Uh4qFIKb2VpQyutZGJOWgWzPQ5BWonvwrnk54O2W63oStMNd0Fpv/dhtNpid
         rgFFffi4a2ApkGu2CENSOZOdTsrHwee2c80aNfZWlGaCgOnfMkMUlNKoU1eFHbO5EMe2
         y+1kVq0ZiQ8+mPbHAd3wuQA6WFL7nJ2dVWF5Q=
MIME-Version: 1.0
In-Reply-To: <s5hmyarq5bh.wl%tiwai@suse.de>
References: <s5hskkli38v.wl%tiwai@suse.de>
	 <b6a2187b0904062304u609c6598i6d76a991b5ab0122@mail.gmail.com>
	 <s5hmyarq5bh.wl%tiwai@suse.de>
Date: Wed, 8 Apr 2009 20:56:11 +0800
Message-ID: <b6a2187b0904080556gdab1382t466c7fd1303800ee@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates for 2.6.30
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, perex@perex.cz,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 9:53 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 7 Apr 2009 14:04:28 +0800,
> Jeff Chua wrote:
>>
>> I encountered this oops with the latest linux git pull. Will this
>> update fix the problem? When I rolled back to 2.6.29-stable, the sound
>> works find.
>>
>> Oops from dmesg ...
>
> Judging also from other bug reports, this looks like Analog codec
> specific.  Likely it's a typo or so...
>
> Could you add probe_only=1 module option and load the module, then
> run alsa-info.sh output with --no-upload option and attach the
> generated file?  The script is found at
>    http://www.alsa-project.org/alsa-info.sh
>
> (BTW, I'm on vacation now, and I'll check this bug after Easter
>  holidays.  Sorry for inconvenience.)

Good news is the latest linux git pull today makes the HDA opps go
away. It's all good now.

Thanks and Happy Easter!

Jeff.
