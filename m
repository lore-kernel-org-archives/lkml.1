Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZKMS1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZKMS1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZKMS1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:27:52 -0500
Received: from csldevices.co.uk ([77.75.105.137]:57984 "EHLO
	mhall.vps.goscomb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756608AbZKMS1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:27:51 -0500
X-Greylist: delayed 2424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 13:27:51 EST
Message-ID: <4AFD9BAF.1010200@csldevices.co.uk>
Date: Fri, 13 Nov 2009 17:47:27 +0000
From: Philip Downer <phil@csldevices.co.uk>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: firmware loading interface
References: <4AFD971C.3090204@csldevices.co.uk>
In-Reply-To: <4AFD971C.3090204@csldevices.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working for a company which is manufacturing a new pci card. The
details are probably irrelevant at this stage, but for those who might
be concerned the driver will be covered by the GPL and submitted
upstream at or before the launch of the card.

Currently I'm investigating how to provide firmware upgrades for the
card, and I've been looking at the request_firmware api. All of the
documentation (and mails that I've read from lkml archives) suggest that
request_firmware is for use with devices without firmware stored in
flash or eeprom, and to load it in to memory at initialisation of the
device.

However our device will have flash to store the firmware in and, whilst
it looks as though it would be possible for us to use request_firmware
to provide occasional firmware upgrades from userspace, I can't find any
reference as to whether this is an accepted method for doing so. Could
someone please confirm for me whether or not it's a good idea to use
request_firmware for this, or perhaps point me at another standard
method for doing firmware updates from userspace?

Please note that I am not subscribed to this mailing list, so could
anyone responding please CC me in their response.

Philip Downer


