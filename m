Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbXFSQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbXFSQya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXFSQyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:54:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15815 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbXFSQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:54:23 -0400
Date: Tue, 19 Jun 2007 18:54:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How would I do this? (expert tricks) OT
In-Reply-To: <456863.7892.qm@web52512.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0706191852360.5731@fbirervta.pbzchgretzou.qr>
References: <456863.7892.qm@web52512.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 19 2007 09:48, Marc Perkel wrote:
>
>I have a server with port 25 closed. I was to be able
>to run a script every time someone tries to connect to
>port 25, but from the outside the port remains closed.
>I need the script that I'm going to run get the IP
>address that tried to connect.
>
>I know it's off topic but it's part of an experiment
>to stop spam. 

tcpdump -lni any port 25
iptables -p tcp --dport 25 -j NFQUEUE
...



	Jan
-- 
