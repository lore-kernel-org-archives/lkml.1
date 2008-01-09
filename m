Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYAIQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYAIQ0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYAIQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:26:41 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:27043 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYAIQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:26:40 -0500
Date: Wed, 9 Jan 2008 09:26:39 -0700
From: Alex Chiang <achiang@hp.com>
To: Micah Parrish <micah.parrish@hp.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] Input: tell mousedev to handle remote console
	virtual mice using absolute coordinates
Message-ID: <20080109162639.GA30033@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Micah Parrish <micah.parrish@hp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pete Zaitcev <zaitcev@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1198188164.7371.40.camel@strongbad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198188164.7371.40.camel@strongbad>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

* Micah Parrish <micah.parrish@hp.com>:
> Devices like the HP Integrated Remote Console Virtual Mouse, which are
> standard equipment on all Proliant and Integrity servers, produce
> absolute coordinates instead of relative coordinates.  This is done to
> synchronize the position of the mouse cursor on the client desktop
> with the mouse cursor position on the server.  Mousedev is not
> designed to pass those absolute events directly to X, but it can
> translate them into relative movements.  It currently does this for
> tablet like devices and touchpads.  This patch merely tells it to also
> include a device with ABS_X, ABS_Y, and mouse buttons in its list of
> devices to process input for.
> 
> This patch enables the mouse pointer to move when using the remote
> console.  Without this patch, the cursor will not move.

We're looking to get this patch accepted into a distro, which is
of course easier if it is first accepted upstream.

Is there anything we can do to help explain this patch further to
enable acceptance?

Thanks.

/ac

