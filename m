Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYGSF2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYGSF2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 01:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYGSF2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 01:28:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8904 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYGSF2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 01:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MHhPwg3aqM1yLzpfzaBBYUW9rO3BNpWvAzCYomrtaan0wnaww1p8pIfw1qv5eQRQRS
         BkhTT7U1WNXLaocb12Y1tbhg7Tkw2a8A1b+tlJkfWcBANLMSh1L+xwHpsnbK5OfzU1vy
         z3zYWsv0cyWmGTdSjX2JDgu5F5IQBTpJI8Dro=
Message-ID: <86802c440807182228u5259eba1x238ec3af5fc4324c@mail.gmail.com>
Date: Fri, 18 Jul 2008 22:28:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080719051227.GA10044@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <20080718202118.GC24122@elte.hu>
	 <86802c440807181326l489b7763sdb040f5b6e575d8c@mail.gmail.com>
	 <20080719005849.GA9055@bromo.msbb.uc.edu>
	 <86802c440807181822l5138ff85k7d8c2e2702a11025@mail.gmail.com>
	 <20080719032845.GA9662@bromo.msbb.uc.edu>
	 <86802c440807182145s58ce6cb2xfc85a6fc849a2a73@mail.gmail.com>
	 <20080719051227.GA10044@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 10:12 PM, Jack Howarth
<howarth@bromo.msbb.uc.edu> wrote:
>   Would that imply that this might be more fallout of the BIOS bug in the
> MacBook Pro where insufficient address space is reserved for the number of
> buses claimed?

that is good enough with 64 buses like laptop.

> Is there some point in the PCIEASPM based code where you
> could duplicate the same sort of fix? I would be happy to test any debug
> patches that might help pinpoint where such a fix is needed.

Jesse, who is maintainer for ASPM code?

YH
