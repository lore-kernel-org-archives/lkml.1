Return-Path: <linux-kernel-owner+w=401wt.eu-S1945943AbXBIAdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945943AbXBIAdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945945AbXBIAdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:33:37 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:42124 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945943AbXBIAdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:33:36 -0500
Date: Fri, 9 Feb 2007 01:31:58 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Christopher R. Hertel" <crh@ubiqx.mn.org>
cc: linux-cifs-client@lists.samba.org, Steve French <smfrench@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: SMB support still missing?
In-Reply-To: <45CBC072.90102@ubiqx.mn.org>
Message-ID: <Pine.LNX.4.61.0702090130440.8587@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0702090101490.24888@yvahk01.tjqt.qr>
 <45CBC072.90102@ubiqx.mn.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 18:29, Christopher R. Hertel wrote:
>Jan Engelhardt wrote:
>
>It does seem to me that it is some sort of name resolution issue, but it may
>have more to do with the multi-homed nature of your setup.
>
>Did you try:
>
>  mount.cifs //CL0/c /mnt

Yes, that one _fails_ with "mount error 112 = Host is down" (though tcpdump
_does_ show that cifs connects to port 139 and then disconnects using FIN)

>If mount.cifs is not converting the case, that should fix the problem.
>Curious to know...


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
