Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbXKOWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbXKOWY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762873AbXKOWYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:24:48 -0500
Received: from main.gmane.org ([80.91.229.2]:48842 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049AbXKOWYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:24:47 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Treat disk space like memory space
Date: Thu, 15 Nov 2007 17:24:32 -0500
Message-ID: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: vpn-132-204-232-80.acd.umontreal.ca
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
Cancel-Lock: sha1:IztzGT1jIOLSGHTpQtpy0dNh5E0=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The normal situation on the memory is side is that most of the memory is
in use, but some pages are ready to be discarded, they're just kept
around because we have nothing better to do (yet) with that page.

Is there a tool to do something similar with file systems.  I have a lot
of unimportant files in my file-system, typically browser caches and
things like that, which can be thrown away without any risk of
losing data.  I just keep them around because I have nothing better to
do with my disk space.

So I'd like to be able to say "these areas of my file-system hold data
that you can discard whenever you need space".  So I can freely fill up
my disk with such irrelevant data, safe in the knowledge that if I ever
need this disk space it'll be automatically reclaimed.

[ I realize this is probably better implemented outside of the kernel, but
  it seems like it might be of interest here.  Please redirect me to
  a more appropriate place if you can think of one (other than
  /dev/null that is).  ]


        Stefan

