Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXCJXqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXCJXqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 18:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXCJXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 18:46:35 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:33157 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXCJXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 18:46:33 -0500
Date: Sun, 11 Mar 2007 00:43:34 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kanhu Rauta <choiskanhu@gmail.com>
cc: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org,
       kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: IP Defragmentation
In-Reply-To: <4c348ac20703072215x63a7a315kd018e433c7a197d2@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703110042460.26332@yvahk01.tjqt.qr>
References: <4c348ac20703072215x63a7a315kd018e433c7a197d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 8 2007 11:45, Kanhu Rauta wrote:
>
> 1>in case of fragmention i am getting only one packet at the
> hook,While analyzing the ip header it says this is the assembled
> packet(skb->len=1528,offset=0,MF=0).

conntrack assembles defragmented packets.

> While dumping the data(for 0 to 1528 print skb->data[i]) it shows that
> only 1472 bytes are valid data and rest 28 bytes are something
> garbage.

Have you forgotten to use skb_header_pointer()?



Jan
-- 
