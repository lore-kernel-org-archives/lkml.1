Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYHBSQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYHBSQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758086AbYHBSQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:16:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49930 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbYHBSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:16:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4894A46D.10607@s5r6.in-berlin.de>
Date: Sat, 02 Aug 2008 20:16:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: ben.collins@ubuntu.com, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/10] drivers/ieee1394: Use DIV_ROUND_UP
References: <Pine.LNX.4.64.0808021712460.20095@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0808021712460.20095@ask.diku.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> -#define bytes_to_quads(_b) (((_b) + sizeof(u32) - 1) / sizeof(u32))
> +#define bytes_to_quads(_b) DIV_ROUND_UP(_b, sizeof(u32))
...
> -	return (dg_size + adj_max_payload - 1) / adj_max_payload;
> +	return DIV_ROUND_UP(dg_size, adj_max_payload);

I cut the changelog down to the necessary and committed it to 
linux1394-2.6.git.  Thanks,
-- 
Stefan Richter
-=====-==--- =--- ---=-
http://arcgraph.de/sr/
