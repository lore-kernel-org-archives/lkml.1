Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYEPG2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYEPG2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYEPG2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:28:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57461 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYEPG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:28:13 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Date: Fri, 16 May 2008 08:28:12 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com, Dean Anderson <dean@sensoray.com>
References: <20080514205927.GA13134@kroah.com> <20080515235102.756407d3@gaivota>
In-Reply-To: <20080515235102.756407d3@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805160828.13856.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 Mai 2008 04:51:02 schrieb Mauro Carvalho Chehab:
> > +static DEFINE_MUTEX(usb_s2255_open_mutex);
> 
> Hmmm... what happens if the user plugs two or more of such devices?

Concurrent calls to open() will be delayed. Not a problem, if the
firmware issue is fixed as it needs to be.

	Regards
		Oliver

