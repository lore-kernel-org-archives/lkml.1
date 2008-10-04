Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYJDWDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYJDWDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYJDWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:03:43 -0400
Received: from fhw-relay07.plus.net ([212.159.14.148]:54790 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYJDWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:03:42 -0400
Message-ID: <48E7E84B.3020508@yahoo.com>
Date: Sat, 04 Oct 2008 23:03:55 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfkill-input doesn't work until 5 minutes after boot
References: <20081004204342.GA29620@srcf.ucam.org>
In-Reply-To: <20081004204342.GA29620@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: ec1e003c405f8091c2cbd11d24afda0a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> rfkill-input implements debounce as follows:
> 
>         if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> 
> However, task->last is initialised to 0 while jiffies starts at -300*HZ. 
> Any input within 5 minutes of kernel start is therefore ignored. Fix by 
> initialising task->last correctly.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Works for me (saves a huge wait to be able to do wifi toggling via a 
hotkey).

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

-- 
Sitsofe | http://sucs.org/~sits/
