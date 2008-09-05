Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYIELuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYIELuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYIELuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:50:03 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:59839 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbYIELuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:50:01 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: How to find origin PID of a sk_buff in iptables match?
References: <b8ixO-2NS-5@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Fri, 05 Sep 2008 14:49:59 +0300
In-Reply-To: <b8ixO-2NS-5@gated-at.bofh.it> (Markku Savela's message of "Thu\, 04 Sep 2008 10\:40\:08 +0200")
Message-ID: <873akeu80o.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Actually, my problem can be reduced to a question:

 Can someone explain why core/sock.c in function sock_init_data sets

    sk->sk_peercred.pid = 0;
    sk->sk_peercred.uid = -1;
    sk->sk_peercred.pid = -1;

 instead of assigning default values from the current task context?
