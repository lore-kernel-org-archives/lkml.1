Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbYLWMce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbYLWMce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYLWMcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:32:20 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:50308 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYLWMcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:32:18 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Checking a USB drive's capacity
Date: Tue, 23 Dec 2008 13:32:32 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <Pine.LNX.4.44L0.0812181641540.2217-100000@iolanthe.rowland.org> <49506E5B.5090604@shaw.ca>
In-Reply-To: <49506E5B.5090604@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812231332.32818.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 23. Dezember 2008 05:51:39 schrieb Robert Hancock:
> It seems to me that the safest solution would be to mark USB storage 
> devices as unsafe for last-sector partition table probing, like some 
> kind of CAPACITY_DUBIOUS flag, causing it to be skipped on these 
> devices, at least by default. After all, it would seem quite unusual to 
> see anything other than a DOS-style partition table on a USB storage 
> device (or else no partition table at all).

That would not help if user space (especially udev helpers) go for the end
of the device.

	Regards
		Oliver

