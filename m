Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZEWVtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZEWVtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZEWVtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:49:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:16811 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZEWVtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nHQETxMO9oAaeeDcEtiO0GmY8kP26iKjX8ILgjfOAaOWGvnjENoA2UUAPG6pj3s3ir
         03gyBhNZqxHRiLj/ugYQOJoUuzIGTs3nOTwHJHdrp9cU7bf9UJ1qpsCBGCSaG3PqkvwB
         tzYM/U5HDVcL48femVr6wwdwi4R6KBmhzvkNs=
MIME-Version: 1.0
In-Reply-To: <20090523140830.5bff23c3@infradead.org>
References: <dd18b0c30905231129j7ad812e9sf3eee89864b03fb8@mail.gmail.com>
	 <20090523140830.5bff23c3@infradead.org>
Date: Sat, 23 May 2009 14:49:36 -0700
Message-ID: <dd18b0c30905231449v41a76c3cn28fd3e03fdfebdb9@mail.gmail.com>
Subject: Re: running the kernel without hal= how safe with the cpufreq
From: Justin Mattock <justinmattock@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 2:08 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 23 May 2009 11:29:29 -0700
> Justin Mattock <justinmattock@gmail.com> wrote:
>
>> I'm in the process of building a system
>> minus hal(since udev 142 explains itself
>> in the README),
>> Anyways I normally just have
>> "ondemand" compiled as the main
>> cpufreq module, and have no powermgnt or cpufreq
>> userspace tool except or was hal.
>> should I be concerned
>> without having hal due to things like this in
>> ps auxZ
>
> if you use ondemand you don't need anything else; the defaults
> are good and in fact very very few people (if anyone) should ever
> change the tunables (they're more aimed for the ondemand developers).
>
> Any application that touches these tunables is basically broken ;)
>
> In addition, you should always be safe against hardware breaking,
> as long as you don't do things like poke chipset registers to disable
> SMM etc, there is thermal protection build into the system.
> First it will automatically slow down the CPU (a lot), and if that is
> not sufficient/fast enough, the system will shut down before it lets
> itself be damaged.
>
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

cool,
alright then my system will have no
powerdaemon, just the kernel running
all of the powermgnt.
(with doing a simple watch cat /proc/cpuinfo)
I notice the cores will spike to full throttle
simultaneously and then lower to low
once a job is done) :^)

regards,


-- 
Justin P. Mattock
