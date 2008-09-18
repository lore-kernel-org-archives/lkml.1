Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYIRJQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYIRJQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYIRJQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:16:42 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:44463 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753265AbYIRJQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:16:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 05:16:41 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sxieUaTPhzJ1oTB+kbUbx5v5LEj/c1PsacPpy8yjE1uiwVdO+aKEQhecM9kZ7u52fXKDWLlxokchN5j54mR0YsOjvyheOAxscY92rxaYfJdrXVfqjqFafqPQDfhtOXq8Pbr7USVyMG5CPR5vJT2PSudexZWIb9JgLIvUmsEExYg=  ;
X-YMail-OSG: e27_77EVM1lXKbiMp_Y_fOx4EPQ5oI3LIFCYM.wa9froOMXrDOnjgTmHEwskahM4h.GJor8kW8q.OtXTuL5WlCUL7CL.DnB5PcpGcz39htSSM10RJJah0l9br7_E5V7fh8D40imRUCpm6i.I6bLGWPSVcxteMtuHFMJTeYQJ2L1oq74QS2kJscs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [19.666764] Disabling IRQ #23
Date: Thu, 18 Sep 2008 02:09:57 -0700
User-Agent: KMail/1.9.9
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "April Tsui" <aprilla@gmail.com>, Linux-usb <linux-usb@vger.kernel.org>
References: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com> <dd18b0c30809171714h23ba6c5wcba2146a9de088f@mail.gmail.com> <dd18b0c30809172144s75bf684am951159218717972e@mail.gmail.com>
In-Reply-To: <dd18b0c30809172144s75bf684am951159218717972e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809180209.57943.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008, Justin Mattock wrote:
> http://www.gossamer-threads.com/lists/linux/kernel/966076
> I've applied the patches just to see what would happen,
> As for now I have not seen the Disable irq #23 yet,

Those two patches should be in Greg's queue for 2.6.27...

It's also suspicious that EHCI is getting loaded *last* not
first.  That's a common distro bug, although as I recall
we've always (since first driver versions) been clear that
it should be loaded first, before the companion (OHCI or UHCI)
driver.  Loading it last causes various confusions and races
at the hardware level.

- Dave
