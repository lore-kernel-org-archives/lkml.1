Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZKNAe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZKNAe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbZKNAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:34:57 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27886 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbZKNAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:34:57 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD+K/UqrRN+K/2dsb2JhbAC9bZgihDwEgW0
X-IronPort-AV: E=Sophos;i="4.44,740,1249257600"; 
   d="scan'208";a="432276481"
From: Roland Dreier <rdreier@cisco.com>
To: Philip Downer <phil@csldevices.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: firmware loading interface
References: <4AFD971C.3090204@csldevices.co.uk>
	<4AFD9BAF.1010200@csldevices.co.uk>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 13 Nov 2009 16:35:01 -0800
In-Reply-To: <4AFD9BAF.1010200@csldevices.co.uk> (Philip Downer's message of
	"Fri, 13 Nov 2009 17:47:27 +0000")
Message-ID: <aday6mac5ai.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Nov 2009 00:35:02.0073 (UTC) FILETIME=[4D88E290:01CA64C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > However our device will have flash to store the firmware in and, whilst
 > it looks as though it would be possible for us to use request_firmware
 > to provide occasional firmware upgrades from userspace, I can't find any
 > reference as to whether this is an accepted method for doing so. Could
 > someone please confirm for me whether or not it's a good idea to use
 > request_firmware for this, or perhaps point me at another standard
 > method for doing firmware updates from userspace?

I think request_firmware() is fine for this... you could have a look at
drivers/net/cxgb3 to see a device that writes new firmware to flash when
it detects a version mismatch between driver and device.

 - R.
