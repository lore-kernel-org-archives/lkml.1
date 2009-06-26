Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZFZL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZFZL7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZFZL7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:59:10 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34857 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZFZL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ty7jF8ft2sSEd9+oyD2STBGLyZGAd6RgTXLStUqJiwF7JbcurHHhbUSMH4rJh12+QU
         95tagEu3qFJKsFElnay1nF5UjufcJFknhkhYuxV2FVF3+X8GMmxNyW5eJqQNWfP3tUW/
         zF033uznSWLMcQGxudLMy95Bx6b3OuOQwB8OM=
MIME-Version: 1.0
In-Reply-To: <200906261336.29318.elendil@planet.nl>
References: <200906261336.29318.elendil@planet.nl>
Date: Fri, 26 Jun 2009 13:59:10 +0200
Message-ID: <8db1092f0906260459n308311faweb6d9733cdd1eb13@mail.gmail.com>
Subject: Re: [2.6.31-rc1] iwlagn (4965): no wireless due to RFKILL problem
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/26 Frans Pop <elendil@planet.nl>:
> I've tried .31-rc1 on my HP 2510p notebook and the only problem I found
> was that wireless no longer works. The cause looks to be related to
> RFKILL.
>

Same on HP/Compaq nx6310, caused by hp-wmi module. It's disable
bluetooth and wireless. I must turn it on in Windows XP (in HP tools).
Workaround: don't load hp-wmi. Already I try find how enable it via
/sys like in Windows.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
