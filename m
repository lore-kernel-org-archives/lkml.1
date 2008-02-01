Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYBAPmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYBAPmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYBAPmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:42:08 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48873 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbYBAPmG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:42:06 -0500
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 10:42:06 EST
Message-Id: <1201879272.2433.1234541483@webmail.messagingengine.com>
X-Sasl-Enc: uhg92/PNnAc++zTqsarPs2uu1NiiigTHWZNgxLtV5PuF 1201879272
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080201145649.GA12318@mailshack.com>
   <20080201150312.GB13992@uranus.ravnborg.org>
Subject: Re: Avoid section mismatch involving arch_register_cpu
In-Reply-To: <20080201150312.GB13992@uranus.ravnborg.org>
Date: Fri, 01 Feb 2008 16:21:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 Feb 2008 16:03:12 +0100, "Sam Ravnborg" <sam@ravnborg.org>
said:
> Hi Alexander.
> 
> See below for my take on the same warning.
> It is already in x86.git pending merge.

Hi!

The patch you forwarded is in Linus' tree already. It only
changed one warning into another one, however. My guess is
that you did not see the new warning due to inlining, but I
compiled with CONFIG_CC_OPTIMIZE_FOR_SIZE=y.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

