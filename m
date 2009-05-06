Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZEFM4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZEFM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbZEFM4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:56:09 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:51508 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbZEFM4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mNBTdwj7w8wP4nwF8tC/NUgIIl0CY9mBOc5SGt3zxjRJ15CBvJ6UkqXZLvONudit6a
         6Gjh0q/JijMbHi20vkw/huYTSvlgmxvPVRczPVb0zch3rPmnCURKm22IrrmPQ9vQZ+ge
         rNSy1zUTJfHouMWWqjlLHGd+eoAZwGIlYyk8c=
MIME-Version: 1.0
Date: Wed, 6 May 2009 08:56:05 -0400
Message-ID: <e6e2252e0905060556i78481be5va8c84635e4c8e227@mail.gmail.com>
Subject: Configuring a PPP Half Bridge/IP Passthru
From: Andrew Watts <systemstalker@gmail.com>
To: linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Im trying to create a PPP Half-Bridge/ZIPB/IP-Passthru so that I can
pass through my public IP address to a device connected to the
ethernet interface of a device that uses a 3G modem for connectivity.
This product exists but I want to do it with my own hardware.  I have
an NSLU2 that I have connected to a 3G cellular into the USB port, I
then want to take the IP address from the resulting PPP and give it to
an embedded device so that it has a publicly routable IP address that
can be accessed directly.  Cradlepoint has such a device, I want to do
the exact same thing just with Linux :).  The link below explains what
I am try to do as well including the product in question.  I cant
bridge a PPP interface to an Ethernet interface, if I had to do that
where would I start to make modifications to the kernel?

http://store.drwireless.com/crceippabrad.html

Anyone have any Idea how I might do that?
