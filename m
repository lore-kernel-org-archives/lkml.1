Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbXEXDt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbXEXDt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbXEXDtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:49:50 -0400
Received: from 1wt.eu ([62.212.114.60]:2729 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbXEXDtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:49:49 -0400
Date: Thu, 24 May 2007 05:49:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to produce a core
Message-ID: <20070524034913.GN943@1wt.eu>
References: <4655064F.1030808@alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4655064F.1030808@alcatel-lucent.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:28:15AM +0800, gshan wrote:
> This morning, I tried command "kill -7 [pid]" but didn't see the core 
> file. Anybody has ideas?

do the following before starting your program :

# ulimit -c unlimited

You can check before and after that the core size changed from 0 to
"unlimited" :

# ulimit -a

Willy

