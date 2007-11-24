Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbXKXOTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbXKXOTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 09:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXKXOTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 09:19:38 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49372
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXKXOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 09:19:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: radeonfb i2c regression post-2.6.18.
Date: Sat, 24 Nov 2007 15:18:26 +0100
User-Agent: KMail/1.9.6
Cc: benh@kernel.crashing.org, Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       linux-kernel@vger.kernel.org, Dennis Munsie <dmunsie@cecropia.com>
References: <1195427766.7022.18.camel@pasglop> <200711231700.53103.mb@bu3sch.de> <20071123232928.467378a7@hyperion.delvare>
In-Reply-To: <20071123232928.467378a7@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711241518.26755.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 November 2007 23:29:28 Jean Delvare wrote:
> On Fri, 23 Nov 2007 17:00:52 +0100, Michael Buesch wrote:
> > This patch fixes my crash problem.
> 
> Out of curiosity, what kind of crash was it? I admit that I can't see
> how the code could crash.
> 

It's not the code that crashes. It's the hardware that turns off the machine.
It only happens if I boot the machine and only if it's hot at this
time. Some hardware will turn off the hardware two or three seconds
after the radeon driver was loaded.
It seems to be some overheating protection that's going crazy.

-- 
Greetings Michael.
