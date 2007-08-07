Return-Path: <linux-kernel-owner+w=401wt.eu-S1765921AbXHGBkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765921AbXHGBkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 21:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbXHGBkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 21:40:42 -0400
Received: from 66-23-224-81.clients.speedfactory.net ([66.23.224.81]:39080
	"EHLO shuttle.linxdev.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbXHGBkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 21:40:41 -0400
X-Greylist: delayed 4083 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 21:40:40 EDT
Subject: Re: sending raw packets via PPP
From: Christopher Fowler <cfowler@outpostsentinel.com>
To: Kevin K <k_krieser@sbcglobal.net>
Cc: James Carlson <carlsonj@workingcode.com>, linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <E210D1E9-9265-48EE-91BB-E6027547F01E@sbcglobal.net>
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net>
	 <18103.44797.529894.786033@gargle.gargle.HOWL>
	 <E210D1E9-9265-48EE-91BB-E6027547F01E@sbcglobal.net>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 20:32:29 -0400
Message-Id: <1186446749.29150.40.camel@shuttle.linxdev.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 19:24 -0500, Kevin K wrote:
> The DHCP source code therefore wants  
> to send raw packets (SOCKET_PACKET) (down to the ethernet addressing  
> info).  

I can imagine that would be the case.  The box requesting the DHCP
address has no IP address.  Therefore TCP/IP can not be used at that
point to communicate between the two.  I've not had to look at the DHCP
code to see how this works.



