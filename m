Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZINO5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZINO5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZINO5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:57:19 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54023 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZINO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=f6yj8Wun6PfYTa88+Z6qXhPuthGgBm+DULgZhIkxDZWNHozxIc1DQvUi41CVbetGHl
         M7MmNIiZl7E53QtoJ1xO/qtD4FAuGQQt6O+b3AX/Dk75tSR0YEZ5fA1tQes7wEvkmGHM
         5jH0ttdjsLS0QRZQGiLFzS3+O/WXgc4XkMMLg=
Message-ID: <4AAE59CB.8030702@tuffmail.co.uk>
Date: Mon, 14 Sep 2009 15:57:15 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Corentin Chary <corentincj@iksaif.net>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] rfkill_unregister() should always be followed by
 rfkill_destroy()
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net> <20090914132401.GC32253@khazad-dum.debian.net>
In-Reply-To: <20090914132401.GC32253@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 14 Sep 2009, Corentin Chary wrote:
>   
>>  drivers/platform/x86/dell-laptop.c   |   36 ++++++++++++++++++++++-----------
>>  drivers/platform/x86/hp-wmi.c        |    2 +-
>>  drivers/platform/x86/thinkpad_acpi.c |    1 +
>>     
>
> These are also likely needed in 2.6.31, please add appropriate Cc: lines to
> stable@kernel.org while adding the Acked-By's.
>
>   

Do they meet the -stable criteria?

...
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.
... (Documentation/stable_kernel_rules.txt)

Regards
Alan
