Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbXEAUJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbXEAUJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXEAUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:09:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:58498 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXEAUJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=iOX6duclRX/2HGBNJuH1e75V5XyjPAMuypcByX1/zZ5tZNN5ZG58J4gBnul+WiLGobIUnzKm9oStD9HStKMHrS7dgPsj1/ZQk/q0ywEykUsL7DJZta9fjMjztTl4lfpwbuvnxzj24893Npsoqf+DlPfNTWGZ8UKYwne+CraoDys=
Date: Tue, 1 May 2007 23:09:02 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <281618366.20070501230902@gmail.com>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
CC: ian <spyro@f2s.com>, kernel-discuss@handhelds.org,
       <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [Kernel-discuss] Re: [RFC, PATCH 0/4] SoC base drivers
In-Reply-To: <46379027.7050202@gmail.com>
References: <1354376306.20070501080806@gmail.com>  <46374645.2030900@gmail.com> <1068016897.20070501173657@gmail.com>  <46376AD9.3020701@gmail.com> <1178042924.15769.5.camel@wirenth> <46379027.7050202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

Tuesday, May 1, 2007, 10:08:23 PM, you wrote:

> ian wrote:
>> On Tue, 2007-05-01 at 20:29 +0400, Dmitry Krivoschekov wrote:
>>> If you used ASIC acronym it would be more appropriate and not so
>>> ambiguous. 
>>
>> Actually, thats not bad. I'd be ok with that is SoC isnt used.
>>
> I'm ok with that too, i.e. very rough definition is:
> SoC (system-on-chip) is  a platform level chip which incorporates processor
> devices (CPU, cache, coprocessors, memory controller etc.), system devices
> (timers, interrupt controllers etc.) and peripheral devices
> (UARTs, LCD controllers, USB controllers etc),
> while ASIC (Application-specific integrated circuit) is also a platform
> level
> chip which incorporates peripheral and system devices but does not include
> processor devices.  ASICs are designed to expand processor functionality,
> it could supplement a normal processor (non-SoC) and also could supplement
> a SoC processor.


> ASIC-related code (I mean core) forms additional platform layer, so I
> suggest
> adding ASIC helpers to generic platform code i.e. drivers/platform.c, but
> ASIC drivers to drivers/asic/ directory.

        There problem here is the same - our target chips are not
just ASICs. It just happens that the one we start with called such,
but we have different ones too. It's still important that they contain
blocks with different functionality, and drivers we propose deal with
basic, common functionality of chips. Now that it was pointed out that
there's place in the tree for such drivers, it would be not wise to
try to create another one.



> Regards,
> Dmitry


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

