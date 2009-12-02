Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZLBJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZLBJRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZLBJRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:17:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53336
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbZLBJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:17:10 -0500
Date: Wed, 02 Dec 2009 01:17:16 -0800 (PST)
Message-Id: <20091202.011716.144426726.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: andrei@iptel.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH] sctp: fix sctp_setsockopt_autoclose compile warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B156862.5020903@hp.com>
References: <20091130094929.GY10897@shell.iptel.org>
	<20091130095250.GZ10897@shell.iptel.org>
	<4B156862.5020903@hp.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 01 Dec 2009 14:02:58 -0500

> 
> 
> Andrei Pelinescu-Onciul wrote:
>> Fix the following warning, when building on 64 bits:
>> 
>> net/sctp/socket.c:2091: warning: large integer implicitly
>>                         truncated to unsigned type
>> 
>> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
> 
> Ack.

Applied, but please submit networking patches always CC:'d
to netdev@vger.kernel.org otherwise they won't get logged
in patchwork and therefore are most likely to get lost.
