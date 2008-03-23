Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbYCWTdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbYCWTdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYCWTc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:32:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48492 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYCWTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:32:58 -0400
Date: Sun, 23 Mar 2008 12:30:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kernel panic, ip_route_input, 2.6.25-rc6-git2
Message-ID: <20080323123021.1826ab73@laptopd505.fenrus.org>
In-Reply-To: <20080323171730.M39052@visp.net.lb>
References: <20080323073638.M89709@visp.net.lb>
	<20080323.031139.17629653.davem@davemloft.net>
	<20080323171730.M39052@visp.net.lb>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2008 19:17:55 +0200
"Denys Fedoryshchenko" <denys@visp.net.lb> wrote:

> What can i do to increase usability?
> 

Enabling CONFIG_FRAME_POINTER tends to make backtraces more reliable.
Making sure that (on 32 bit x86) you use CONFIG_4KSTACKS is enabled also tends
to improve backtrace reliability (less noise from interrupts)

Another good option is to go to www.kerneloops.org and try to see if others 
saw similar backtraces but with less noise

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
