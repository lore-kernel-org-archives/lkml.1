Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbZDCGri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbZDCGri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbZDCGr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:47:27 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43167 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760623AbZDCGr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=u3A107DkdFEx55StAPnzS3EOWGzo9rUwWjoFrVlG9fpKiAzV74Y9ADU0kEVBhay3hz
         nUbJRGr0P1AuMTsdRMphcJMXbd+/NXAZkB/UXFN40EqPRAugl+Ou1NdU/bfGjr0wygPI
         lwZcp8/MT6jGpmxVtRm45vHFbjGcGsJCUOado=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Date: Fri, 3 Apr 2009 08:47:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904030222.57469.a.miskiewicz@gmail.com> <20090403003523.GK18394@sequoia.sous-sol.org>
In-Reply-To: <20090403003523.GK18394@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904030847.19674.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 of April 2009, Chris Wright wrote:
> * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> >
> > stop_machine: introduce stop_machine_create/destroy.
>
> That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.
>
> Can you please verify if 2.6.29 works for you? 

I think that the guilty part is 
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y

Disabling stackprotector makes problem go away (and my build of final 2.6.29 
had it disabled while later builds got it enabled at some moment).

(gcc 4.3.3 here)

> Your bisects are all
> going way back to 2.6.29-rc1.
>
> thanks,
> -chris


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

