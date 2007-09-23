Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXIWGjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXIWGjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXIWGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:39:38 -0400
Received: from main.gmane.org ([80.91.229.2]:52654 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbXIWGjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:39:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: Linux Router
Date: Sun, 23 Sep 2007 08:39:21 +0200
Message-ID: <m34phlx4va.fsf@ursa.amorsen.dk>
References: <e660b2250709221609l1475c061t5a1a78de4fa529f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:5lNoI5xFntBNz8ODqw/hcImq4pQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "CN" == Carlos Narváez <crakup@gmail.com> writes:

CN> - IP Forwarding has been enabled on the router via "echo 1 >
CN> /proc/sys/net/ipv4/ip_forward"

Try cat /proc/sys/net/ipv4/conf/*/forwarding. If any of them are 0,
then echo 1 > /proc/sys/net/ipv4/conf/all/forwarding.


/Benny


