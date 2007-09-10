Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXIJWzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXIJWzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbXIJWzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:55:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38246 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932710AbXIJWzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:55:13 -0400
X-Sasl-enc: MSDPOtEmd4VfFQsRGvjVRHxpdnO7TGZ0xm/voGqBhaFs 1189464918
Date: Mon, 10 Sep 2007 19:55:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yan Burman <burman.yan@gmail.com>
Cc: Shem Multinymous <multinymous@gmail.com>,
       hdaps-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data
	Protection System 3D ACPI driver (resend)
Message-ID: <20070910225509.GC1408@khazad-dum.debian.net>
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com> <20070827171107.GA15647@khazad-dum.debian.net> <46D5A742.8090201@gmail.com> <20070829233024.GA7433@khazad-dum.debian.net> <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com> <46D6E5CD.4060807@gmail.com> <20070830164132.GA21023@khazad-dum.debian.net> <46E5A680.9020706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E5A680.9020706@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Yan Burman wrote:
> But, how are you going to make the sysfs attribute look generic so that 
> application will not have to know whether to go
> to /sys/.../mdps /sys/.../hdaps/ or /sys/.../whatever?

You use a (new, to be designed and implemented) accelerometer class, and
userspace hunts down every device that is a member of that class.  Look at
how hwmon is doing it in 2.6.22+ and lm-sensors CVS.

> I'd probably prefer netlink, since this way it's something more generic and 
> if some more functionality is added, you don't need to start
> adding more sysfs attributes.

But you will need to add extra netlink messages, anyway.  I don't know for
sure what would be the best way.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
