Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYILCm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYILCm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYILCmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:42:18 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:38390 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbYILCmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dtkeIqd7+FtY65DdYSRIAX2yM99am5OTKk3D3eX5ZJtbpLjsDWdopjaphcThpS5mbh
         y5gjd8E5kTvzNbpSR7y6UfyTk34EjIZlYmWrIc2Bl4BXC+PKtDfnHJ9VvlK0ILkw0uZ8
         lpS6PKuHp2O/viwieua/cZYmpZmkytAokgsNs=
Date: Fri, 12 Sep 2008 06:44:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
Message-ID: <20080912024409.GB3670@x200.localdomain>
References: <48C9D040.8010107@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C9D040.8010107@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 09:13:20PM -0500, Larry Finger wrote:
> In file drivers/net/wireless/p54/p54common.c, the statement
>
>        priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);
>
> generates the sparse warning
>
> .../p54common.c:185:29: warning: cast to restricted __le16
>
> where bootrec->data is u32, and priv->rx_mtu is u16.
>
> What should be done to eliminate this warning?

What is the intent?

MTU is 2-byte little-endian starting at 40-th byte?

Oh, and size_t cast is pointless.
