Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZGAF7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZGAF7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZGAF7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:59:10 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38968 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZGAF7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:59:09 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 01:59:08 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VFXOhOkh26RTYeeOD5mYMZzl1WraUaZT1vFmbsdLQfZacwxjoCinjKooPHiD93z4+F
         E7iSaVkf9noVnOT25ETnNtElP8V1ExSk0qRv87ynD3eAc5zNq4GP7wuTtMQBuStO7jHB
         kU1YUmvebnddZn/kAHcxAIe1ut/aZxXvtHO18=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
	 <alpine.DEB.1.10.0906301030260.6124@gentwo.org>
	 <1246374095.8014.28.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906301114450.3879@gentwo.org>
	 <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
	 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0906301722280.17682@gentwo.org>
	 <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
Date: Wed, 1 Jul 2009 08:53:20 +0300
X-Google-Sender-Auth: d4d0c99a7d41be4b
Message-ID: <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Jul 1, 2009 at 12:52 AM, David Rientjes<rientjes@google.com> wrote:
> I think the solution to this is really based on good software engineering
> and test practices, though, so hopefully there'll be a consensus on which
> direction to take before any time is spent in implementing and pushing it.

Lets go with the slab_out_of_memory() patch you outlined in a previous
post and implement the slub_debug=p thing Christoph suggested. I think
it's the best compromise at this point. When you guys finally see the
light, we can always change it to a reasonable default. ;)

So can you send a patch, please?

                        Pekka
