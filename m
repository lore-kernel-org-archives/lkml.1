Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZF0UDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZF0UDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 16:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZF0UC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 16:02:57 -0400
Received: from [200.117.86.35] ([200.117.86.35]:38918 "EHLO
	burns.springfield.home" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257AbZF0UC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 16:02:56 -0400
X-Greylist: delayed 1394 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jun 2009 16:02:55 EDT
Date: Sat, 27 Jun 2009 16:39:27 -0300
From: Leandro Lucarella <llucax@gmail.com>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: Mathias Kretschmer <mathias@blx4.net>,
       "J\. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
Message-ID: <20090627193927.GB25375@homero.springfield.home>
References: <20090521142026.GA5566@geggus.net> <20090528202803.GF13860@fieldses.org> <20090528203228.GA6056@geggus.net> <200906191414.02674.mathias@blx4.net> <20090619124611.GA16337@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619124611.GA16337@geggus.net>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Geggus, el 19 de junio a las 14:46 me escribiste:
> Mathias Kretschmer schrieb am Freitag, den 19. Juni um 14:14 Uhr:
> 
> > For a while my server has been running fine after the upgrade to 2.6.30.
> > My NFS/diskless desktop worked just fine. Then yesterday evening suddenly the 
> > first "reconnect_path: npd != pd" messages popped up.  Sometime during the 
> > night the frequency of those messages showing up increased to > 100 msgs/sec 
> > in average.
> 
> More or less the same here. My client machine (2.6.30) however worked just
> for a few hours. It does however work fine using the older Kernel (2.6.27.x)
> on the Server.
> 
> This is also XFS+NFS here. I will also attach the associated .config of the
> Kernel.

Hi, I want to confirm that I'm still having this problem in 2.6.30. I'm
using Debian (unstable) too, and the exported fs is XFS.

Here is a related bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=13375

-- 
Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/
----------------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
