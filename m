Return-Path: <linux-kernel-owner+w=401wt.eu-S1422960AbXBHX1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422960AbXBHX1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422783AbXBHX1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:27:11 -0500
Received: from directfb.org ([212.227.87.76]:64982 "EHLO www.directfb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030231AbXBHX1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:27:10 -0500
X-Greylist: delayed 1337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 18:27:10 EST
Message-ID: <45CBAC8A.3050806@directfb.org>
Date: Fri, 09 Feb 2007 00:04:42 +0100
From: Denis Oliver Kropp <dok@directfb.org>
User-Agent: Thunderbird 1.5.0.4 (X11/20060619)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       adaplas@pol.net, ajoshi@shell.unixbox.com, pfaffben@debian.org,
       VANDROVE@vc.cvut.cz
Subject: Re: [PATCH 1/2] Video: fb, add true ref_count atomicity
References: <135662331710109923@wsc.cz>
In-Reply-To: <135662331710109923@wsc.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> video/fb, add true ref_count atomicity
> 
> Some of fb drivers uses atomic_t in bad manner, since there are still some
> race-prone gaps. Use mutexes to protect open/close code sections with
> ref_count testing and finally use simple uint.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Denis Oliver Kropp <dok@directfb.org>

-- 
Best regards,
   Denis Oliver Kropp

.------------------------------------------.
| DirectFB - Hardware accelerated graphics |
| http://www.directfb.org/                 |
'------------------------------------------'
