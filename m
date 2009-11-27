Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZK0PdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZK0PdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZK0PdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:33:22 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:65249 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZK0PdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 10:33:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f/0Xj8H9AUtrqvfkhQlZj27fZFlevQyatyWOdyz4Achh7/yZ4n8FmgLWMrlmO0NaUu
         YUS2DCY5OUsqx901x5e7RP23mp9sxqbrZDDeIk65aZRo/vP5crfLuq1x7tW+aXJTAcRB
         QsrNJZ3z3RuuIiH9Hf7FNmCgrqpfjnfQt8q2A=
MIME-Version: 1.0
In-Reply-To: <BDgcSm3ZjFB@christoph>
References: <9e4733910911262106r553bb28brb5bef07dee3aae3b@mail.gmail.com>
	 <BDgcSm3ZjFB@christoph>
Date: Fri, 27 Nov 2009 10:33:27 -0500
Message-ID: <9e4733910911270733j1abbb1ddi962c8a46c9aabe48@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: 
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 2:33 AM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> Hi Jon,
>
> on 27 Nov 09 at 00:06, Jon Smirl wrote:
> [...]
>> code for the fun of it, I have no commercial interest in IR. I was
>> annoyed with how LIRC handled Sony remotes on my home system.
>
> Can you elaborate on this?
> I'm not aware of any issue with Sony remotes.

irrecord can't figure out that Sony remotes transmit multiple
protocols so it reverts to raw mode. When trying to figure that out I
started working on the concept of running simultaneous state machines
to decode the pulse timings.  I also had an embedded system with an IR
receiver hooked to a timer input pin.  I started off with a
implementation that ran multiple Sony protocol decoders and used the
input from the timer pin. I know now that I could use irrecord
individually for each group of keys on the Sony remote and then glue
the flies together. But that's the path that caused me to write the
code.

Also throw into pot that I had previously had some very bad
experiences trying to deal with the old mouse and kbd device inside of
the X server. I was aware that evdev was designed to fix all of those
problems. That made me want a fully evdev based design.

>
> Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
