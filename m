Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYC0I4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYC0I4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYC0I4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:56:34 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52983 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYC0I4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:56:34 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Brad Sawatzky <brad+kernel@swatter.net>
Subject: Re: [PATCH] usb-serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24
Date: Thu, 27 Mar 2008 09:56:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <20080327001557.GA16176@enigma.swatter.net> <Pine.LNX.4.44L0.0803262252420.21714-100000@netrider.rowland.org> <20080327050725.GC11011@enigma.swatter.net>
In-Reply-To: <20080327050725.GC11011@enigma.swatter.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803270956.36892.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 27. März 2008 06:07:26 schrieb Brad Sawatzky:
> FWIW, another option I considered was patching the test added in commit
> 063a2da8f01806906f7d7b1a1424b9afddebc443 to use '<=' instead of '!=' in the
> obvious places.  That is, test if the usb-serial subsystem reports at least
> as many endpoints as the device definition "requires" rather than checking

The problem with that is that if a device adds an endpoint we may use
the wrong endpoints in drivers, depending on how the endpoints in devices
are numbered. As we have no idea what the consequences would be, we rather
fail cleanly.

	Regards
		Oliver


