Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYG2D5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYG2D5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYG2D5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:57:41 -0400
Received: from smtp.knology.net ([24.214.63.101]:60841 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbYG2D5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:57:40 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1217295498.28682.16.camel@obelisk.thedillows.org>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
	 <1217215009.2970.7.camel@jaswinder.satnam>
	 <1217248585.22789.58.camel@obelisk.thedillows.org>
	 <1217253260.17632.6.camel@jaswinder.satnam>
	 <1217295498.28682.16.camel@obelisk.thedillows.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 23:57:36 -0400
Message-Id: <1217303856.28682.21.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 21:38 -0400, David Dillow wrote:
> Now you keep one copy per NIC, which doubles the memory usage. Just use
> static struct firmware *typhoon_fw;

Just to clarify, loading it per-NIC wastes memory when there is more
than one card in the box. I've got two in one of my test boxes, hence
the count above. I've heard tale of many more of these stuffed into a
single box, though there's better ways to achieve their aims these days.

