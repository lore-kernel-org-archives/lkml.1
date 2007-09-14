Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXINUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXINUSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXINUSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:18:33 -0400
Received: from main.gmane.org ([80.91.229.2]:37708 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbXINUSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:18:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Interpretation of sparse warning
Date: Fri, 14 Sep 2007 22:17:49 +0200
Organization: Linux Foundation
Message-ID: <20070914221749.7722cadf@oldman>
References: <46EAE885.3080106@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: port-83-236-241-242.static.qsc.de
In-Reply-To: <46EAE885.3080106@lwfinger.net>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 15:01:09 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The code sequence
> 
>         u32 macstat;
> .....
>         macstat = le32_to_cpu(rxhdr->mac_status);
> 
> generates the following sparse warnings
> 
> drivers/net/wireless/b43legacy/xmit.c:446:12: warning: cast to restricted type
> drivers/net/wireless/b43legacy/xmit.c:446:12: warning: cast from restricted type
> 

Is rxhdr->mac_status properly declared as le32?

