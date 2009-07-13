Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZGMPTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZGMPTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZGMPTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:19:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44068 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbZGMPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cx7QOsC1t5BPNtbCxYB23WXcCbzYENiEckr74SCmGTmbShL142qLo+pVB19g5G6Yij
         7Fc2+mcBtT4ZuzhBMwl6l7bxKnGEz7cCvuGNuBuN78qbh6MHH1+MPQUiuKeWnFwCIPBv
         JzPA6W1dQKO3rN67kL47jgE60pAPlSwZtzYi4=
Date: Mon, 13 Jul 2009 19:47:09 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: fbdev <linux-fbdev-devel@lists.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090713151709.GA1297@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-26)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any reason for not adding these ioctls to fbdev?  I searched
the net and couldn't any.  Anyway, these patches simply implement those
ioctls.

Ali Gholami Rudi (2):
  fbdev: add FBIOFILLRECT ioctl
  fbdev: add FBIOCOPYAREA ioctl

 drivers/video/fbmem.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h    |    2 +
 2 files changed, 52 insertions(+), 0 deletions(-)
