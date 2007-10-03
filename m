Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXJCNG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXJCNG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXJCNGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:06:22 -0400
Received: from main.gmane.org ([80.91.229.2]:35057 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXJCNGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:06:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: top displaying 9999% CPU usage
Date: Wed, 03 Oct 2007 19:03:40 +0600
Message-ID: <4703932C.6060900@ums.usu.ru>
References: <200710031433.34504.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: elendil@planet.nl
X-Gmane-NNTP-Posting-Host: 90.150.136.121
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
In-Reply-To: <200710031433.34504.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> I saw top occasionally displaying 9999% CPU usage for a process. The
> first few times it was amarokapp, this last time it was kontact.
> Both applications were basically idle.
> The "cc1" is a kernel compile (rc9 + CFS :-).
> 
> I cannot remember seeing this before, but as I also don't run top that
> frequently I cannot be sure its a recent regression.

Try to capture the i/o log with the following command:

strace -o top.log top

This will show for sure whether the kernel gives out incorrect data or 
top misinterprets them.


-- 
Alexander E. Patrakov

