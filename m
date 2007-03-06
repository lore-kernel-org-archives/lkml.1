Return-Path: <linux-kernel-owner+w=401wt.eu-S965283AbXCFQhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283AbXCFQhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965303AbXCFQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:37:54 -0500
Received: from main.gmane.org ([80.91.229.2]:58941 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965283AbXCFQhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:37:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Enrico Scholz <enrico.scholz@informatik.tu-chemnitz.de>
Subject: Re: I2O block driver broken in kernel 2.6.19?
Date: Tue, 06 Mar 2007 17:09:35 +0100
Message-ID: <87y7ma9ww0.fsf@fc5.bigo.ensc.de>
References: <45D8E102.6090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p54b4f6c1.dip.t-dialin.net
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
Cancel-Lock: sha1:PNucoj+1xSneAsukE6PuigfKQJc=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> Everything looks like it loads OK, but no block IO can be
> done, not even reading the partition table:

Same here with

| 03:08.0 RAID bus controller: Adaptec (formerly DPT) SmartRAID V Controller (rev 01)
|         Subsystem: Adaptec (formerly DPT) ASR-2010S I2O Zero Channel

on a Dual Xeon (SMP) machine. Tested with (nearly) vanilla kernels
2.6.19.2 + 2.6.20.1 and http://ensc.de/kernel-i2o-config.txt



Enrico

