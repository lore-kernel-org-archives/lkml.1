Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZKQXF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZKQXF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZKQXF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:05:56 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:37885 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbZKQXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:05:55 -0500
Message-ID: <4B032C4E.1020606@ahsoftware.de>
Date: Wed, 18 Nov 2009 00:05:50 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <4AFDED47.5070606@ahsoftware.de> <4AFE1B0D.3060404@ahsoftware.de> <200911141106.51948.oliver@neukum.org> <4AFEE981.8060505@ahsoftware.de> <4B01EC11.4030901@ahsoftware.de> <4B01F3D9.5090003@ahsoftware.de> <4B01F83E.5040905@ahsoftware.de>
In-Reply-To: <4B01F83E.5040905@ahsoftware.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've done some more tests and have some more findings.

After the problem occured (which looks for me like a timeout during a 
wait for a CSW), ehci_hcd doesn't work anymore. Low- and full-speed 
devices are still working and are recognized correctly, but no 
high-speed device. After unloading ehci_hcd and reloading it, high-speed 
devices are recognized correctly again.
As unloading is no option for kernels which have ehci_hcd compiled in 
(like the F11-kernel), is there another option to reset the driver?

Regards,

Alexander
