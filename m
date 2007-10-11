Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbXJKAOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbXJKAOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbXJKAOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:14:09 -0400
Received: from main.gmane.org ([80.91.229.2]:45546 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbXJKAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:14:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: [OT] Argument with an OS professor over profile=3
Date: Thu, 11 Oct 2007 00:13:45 +0000 (UTC)
Message-ID: <loom.20071011T001229-285@post.gmane.org>
References: <f9d2a5e10710101708l707eb619l6446f2e648ee016e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 129.219.69.172 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.6) Gecko/20070919 Galeon/2.0.2 (Ubuntu package 2.0.2-4ubuntu1) (gutsy) Firefox/2.0.0.6)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

                /* only text is profiled */
>                 prof_len = (unsigned *) &_etext - (unsigned *) &_stext;

Crap, sorry, accidentally sent a version I had laying around demonstrating how
one *would* get the answer he expects. The correct line is of course:

prof_len = (unsigned long) &_etext - (unsigned long) &_stext;

