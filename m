Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYEOMDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYEOMDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 08:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYEOMDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 08:03:23 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42945 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYEOMDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 08:03:23 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Date: Thu, 15 May 2008 14:03:18 +0200
User-Agent: KMail/1.9.9
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
References: <20080514205927.GA13134@kroah.com> <200805151338.38801.oliver@neukum.org>
In-Reply-To: <200805151338.38801.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151403.19323.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Mai 2008 13:38:37 schrieb Oliver Neukum:
> 3. The firmware stuff. That's an interesting solution. However:

Actually, on second thought, I take that back. It's a bad solution.
If you don't want to do it in probe(), the only other sensible place
is in open(). That way you can avoid the whole trouble if nobody
opens the device. And you need to handle the case of unloaded
firmware anyway, so you can trigger firmware load there.

	Regards
		Oliver

