Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbYGDRAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbYGDRAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbYGDQyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:54:38 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:31448 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760273AbYGDQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:54:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NBW+s+PJ/Pa1IjqkRli417+zO2cjykIxL/MuB7MlUW8aDdwlbUvrpFHiOnGGGTCI/S8XvTdkXdqmw6eab63RU/8EGjQKOKkHAGYJwfeM4Ty9oWbmLlVWVXrrNgC5FydV2e7pV+cXNvK6ODPJFd42yyE2SiwhTRp3XSssK9qr/04=  ;
X-YMail-OSG: Ew0mvCEVM1ld961XiPB_.8__e8oTZnugE4XxzVoobJ6NQvAPbjqcndJYz6y9EHLBzQBEpRa5BBd7AEuPOCv2.k3RF0yioIk8p61kv3vEFQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Date: Fri, 4 Jul 2008 09:54:34 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <20080704142208.GB4576@doriath.ww600.siemens.net> <s5hwsk1k6yj.wl%tiwai@suse.de>
In-Reply-To: <s5hwsk1k6yj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807040954.34838.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2008, Takashi Iwai wrote:
> 
> > Please submit a patch where HAVE_GPIO_LIB selects GENERIC_GPIO.
> 
> Hmm... just checking again, I found GENERIC_GPIO isn't defined in
> drivers/gpio/Kconfig but in each arch Kconfig.  So we can't select it
> unconditionally.
> 
> I'm not sure whether it's a better fix at this moment.

Which platform is it which is trying to declare that it has
an implementation (HAVE_GPIO_LIB) of an interface that it
doesn't support (GENERIC_GPIO unset) ??


