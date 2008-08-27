Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbYH0OKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbYH0OKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbYH0OCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:02:10 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:51077 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759371AbYH0OCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:02:07 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Wed, 27 Aug 2008 17:00:35 +0300
User-Agent: KMail/1.9.9
Cc: Eric Dumazet <dada1@cosmosbay.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200808220457.40892.denys@visp.net.lb> <200808271509.18529.denys@visp.net.lb> <20080827123635.GA25321@2ka.mipt.ru>
In-Reply-To: <20080827123635.GA25321@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271700.36029.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008, Evgeniy Polyakov wrote:
> Can you put debug print into
> net_enable_timestamp()/net_disable_timestamp() to determine if someone
> enabled timestamp socket option?
OK, i will do that on next system reboot.

> > 0.0.0.0:*                          3207/udhcpd
>
> This one looks suspicious                                                  
>      ^^^^^^^^^^
It is busybox udhcpd... i guess it is innocent. Even i kill it - it doesn't 
change anything at all. 
Only who possible listen multicast socket - it is ripd, i cannot kill him. But 
i think it doesn't matter much too...

