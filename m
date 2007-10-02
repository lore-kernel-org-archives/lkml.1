Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbXJBWYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbXJBWYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXJBWX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:23:57 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34902 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXJBWX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:23:57 -0400
Message-ID: <4702C4F4.5060107@davidnewall.com>
Date: Wed, 03 Oct 2007 07:53:48 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: gogi-k@gogi.tv
CC: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
References: <200710021256.08469.gogi-k@gogi.tv>
In-Reply-To: <200710021256.08469.gogi-k@gogi.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuliano Gagliardi wrote:
> I have a server that has to switch to different user ids, but because it does 
> other complex things, I would rather not have it run as root. I only need the 
> server to be able to switch to certain pre-defined user ids.

Why don't you use group security instead of user security; you already 
have supplemental group id's.
