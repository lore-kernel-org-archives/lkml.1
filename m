Return-Path: <linux-kernel-owner+w=401wt.eu-S932173Ab0AVCxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0AVCxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889Ab0AVCxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:53:54 -0500
Received: from bungle.evilgeniuses.org.uk ([195.10.223.155]:50066 "EHLO
	bungle.evilgeniuses.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab0AVCxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:53:54 -0500
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <51f3faa71001211830s1744809eu3d3c5b7753656822@mail.gmail.com>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
	 <4B58CBEE.5020301@gmail.com>
	 <51f3faa71001211629n1b556649t32c184e49dc32dfb@mail.gmail.com>
	 <4B58FD48.9020209@gmail.com>
	 <1264126146.28766.0.camel@localhost.localdomain>
	 <51f3faa71001211830s1744809eu3d3c5b7753656822@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 02:53:52 +0000
Message-ID: <1264128832.29434.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 20:30 -0600, Robert Hancock wrote:
<snip>
> So it doesn't report any keyboard or mouse controller. You're sure
> that "PNP: No PS/2 controller found" message doesn't show up?

Probably wrong kernel I was testing. I get, on an older kernel:
PNP: No PS/2 controller found. Probing ports directly.

So it would poke at it directly, which might cause hangs. The symptoms
is that, sometimes, the machine will hang on boot until I press the
power button, when it would continue.

Let me know if you know another way to blacklist the i8042 probing on
those machines...

