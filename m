Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbXBNXRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbXBNXRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXBNXRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:17:55 -0500
Received: from smtpout11-02.prod.mesa1.secureserver.net ([68.178.232.2]:33227
	"HELO smtpout11-02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751289AbXBNXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:17:55 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 18:17:55 EST
Date: Wed, 14 Feb 2007 16:11:14 -0700
From: akennedy@techmoninc.com
Subject: Re: Serial console issues.
To: linux-kernel@vger.kernel.org
Message-ID: <20070214161114.bfc52cea95091b0fffcb409eab6296ba.39d16a8e24.wbe@email.secureserver.net>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=US-ASCII
User-Agent: Web-Based Email 4.9.14
X-Originating-IP: 68.209.83.41
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous post I incorrectly stated that my serial port is a
TI16750, as this is what /proc/tty/... revealed to me.  After
re-reading the product manual, I see that this is actually a 16550. 
Since Linux is seeing this port as a 16750, could that explain why I'm
seeing missing characters in the transmission.  After doing some
research, I found that the 16750 has a 64-byte buffer, whereas I know
this to only have a 16-byte buffer.

If my assumptions are correct and Linux is detecting this serial port
incorrectly, how can I force the serial driver to see this a 16550?

Thanks again for any assistance you can provide,

Andy Kennedy

