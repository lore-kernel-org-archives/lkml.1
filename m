Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0BTCYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 21:24:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37894 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0BTCYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 21:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=pQEMJAqoYR558UkdRULhD+F3bngm2UYSwiydNKG6aL3wD7hLpWUzx6A2AayPy5h44w
         M1ktB4Ph8QQGvVZW+QkHRmZ3QZEe+7bAqgKrwi7GAQqGdpkB0BubjewuxUlRmNFyDGRF
         PvtSfBcgXngbexLLJhzx3MdzThgvwZRNdxGsU=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Feb 2010 18:23:47 -0800
Message-ID: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
Subject: Firmware versioning best practices II
To: linux-kernel@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last year, with the help of the community we at Atheros opened up the
first (to my knowledge) firmware for a device driver used on the Linux
kernel. The community has been advancing the firmware and making
changes and even an alternative driver with more features is being
baked. We hadn't dealt with open firmware before and this itself
raises a few management questions about the firmware APIs, code
revision and general best practices which are likely not documented
anywhere. We reviewed this on linux-wireless last year [1] and Pavel
Roskin made a good suggestion for model to follow. I still have a few
more questions though and wanted a wider review on this.

I've documented a summary of what we have discussed and suggested so far here:

http://wireless.kernel.org/en/developers/Documentation/firmware-versioning

We should still address how drivers should deprecate firmware. Can we
deprecate old firmware APIs from drivers on each kernel release? Any
other comments or feedback?

[1] http://wireless.kernel.org/en/developers/Documentation/firmware-versioning

  Luis
