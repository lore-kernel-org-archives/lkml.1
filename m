Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYAGLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYAGLK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYAGLKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:10:17 -0500
Received: from rosi.naasa.net ([212.8.0.13]:53985 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYAGLKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:10:16 -0500
X-Greylist: delayed 1142 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 06:10:16 EST
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: regression: 100% io-wait with 2.6.24-rcX
Date: Mon, 7 Jan 2008 11:51:10 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801071151.11200.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when booting kernel 2.6.24-rc{4,5,6,7} top reports up to 100% iowait, even if 
no program accesses the disc on my Thinkpad T40p. Kernel 2.6.23.12 does not 
suffer from this. Is there anything I can do to find out which process or 
which part of the kernel is responsible for this? I can try to bisect it, but 
maybe there are other possibilities to debug this, since I cannot boot this 
computer frequently. I discovered, that there is no iowait within the first 
few seconds after waking up from suspend to ram...

regards,
Jörg

