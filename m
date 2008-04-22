Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYDVQEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYDVQEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYDVQEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:04:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:41977 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYDVQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:04:34 -0400
Subject: Re: [PATCH 1/3] radeonfb: Fix 64 bits resources on 32 bits archs
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Hollis Blanchard <hollisb@us.ibm.com>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Detlev Zundel <dzu@denx.de>
In-Reply-To: <480E0A54.9010203@linux.vnet.ibm.com>
References: <20080422012723.BA9F2DE13F@ozlabs.org>
	 <480E0A54.9010203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: Tungsten Graphics
Date: Tue, 22 Apr 2008 18:04:29 +0200
Message-Id: <1208880269.5632.262.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 17:55 +0200, Christian Ehrhardt wrote:
> 
> You see it e.g. when you try to initialize X11, the x11 radeon driver
> issues a FBIOGET_FSCREENINFO ioctl [...]

FWIW, current versions of the xf86-video-ati radeon driver no longer use
radeonfb for anything.


-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer

