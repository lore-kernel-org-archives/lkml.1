Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbXBDL4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbXBDL4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 06:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbXBDL4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 06:56:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:58317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751898AbXBDL4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 06:56:03 -0500
X-Authenticated: #1045983
From: Helge Deller <deller@gmx.de>
To: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] HIL small fix
Date: Sun, 4 Feb 2007 12:55:57 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
References: <20070204074758.GA10596@cvg>
In-Reply-To: <20070204074758.GA10596@cvg>
X-Face: *4/{KL3=jWs!v\UO#3e7~Vb1~CL@oP'~|*/M$!9`tb2[;fY@)WscF2iV7`,a$141g'o,=?utf-8?q?7X=0A=09=3FBt1Wb=3AL7K6z-?=<?-+-13|S_ixrq58*E`)ZkSe~NSI?u=89G'J<n]7\?[)LCCBZc}~[j(=?utf-8?q?e=7D=0A=09=60-QV=7B=23=25=26=5B=3F=5EfAke6t8QbP=3Bb=27XB?=,ZU84HeThMrO(@/K.`jxq9P({V(AzezCKMxk\F2^p^+"=?utf-8?q?=0A=09=5B?="ppalbA!zy-l)^Qa3*u/Z-1W3,o?2fes2_d\u=1\E9N+~Qo
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041255.57835.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

thanks a lot for the patch.
I've applied it to the PARISC-Linux git tree:
http://git.parisc-linux.org/?p=linux-2.6.git;a=commit;h=2b1f35b1cdec70c3a0ee2d4174668597355b6041

Your patch made me aware of an unitialized spinlock in the code as well:
http://lists.parisc-linux.org/pipermail/parisc-linux-cvs/2007-February/037203.html

Regards,
Helge

On Sunday 04 February 2007, Cyrill V. Gorcunov wrote:
> This patch adds a checking for errors in hil_keyb_init.
> Also some extra spaces are removed.
> 
> Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
> 
> ---
> 
>  dvers/input/keyboard/hilkbd.c |  106 +++++++++++++++++++++++----------------
>  1 files changed, 62 insertions(+), 44 deletions(-)
