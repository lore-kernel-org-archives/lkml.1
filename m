Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYCZHR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYCZHR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYCZHRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:17:19 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:45450 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYCZHRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:17:18 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Brad Sawatzky <brad+debian@swatter.net>
Subject: Re: [PATCH] usb-serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24
Date: Wed, 26 Mar 2008 08:17:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <20080326023243.GA25564@enigma.swatter.net>
In-Reply-To: <20080326023243.GA25564@enigma.swatter.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803260817.18330.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. März 2008 03:32:43 schrieb Brad Sawatzky:
> Fixes a bug/inconsistency revealed by the additional sanity checking in
>    commit 063a2da8f01806906f7d7b1a1424b9afddebc443
> introduced in the original 2.6.24 branch.
> 
> The Handspring Visor / PalmOS 4 device structure defines .num_bulk_out=2
> but the usb-serial probe returns num_bulk_out=3, triggering the check in
> the above commit and forcing a bail out when the device (a Garmin iQue in
> my case) attempts to connect.  The patch bumps the expected number of
> endpoints to 3.
> 
> I suppose it's possible that the kernel is identifying 3 bulk endpoints
> when there should only be 2 and there is some issue with the lower level
> endpoint probe?

Send in "lsusb -v". Are you sure all devices have 3 endpoints?

	Regards
		Oliver
