Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbXLMHWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbXLMHWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762353AbXLMHHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:07:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:56127 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763598AbXLMHH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tk1Xl5HBmzYxGvGN/h7P0zJ8c/8HLy9qInzl40nOK68d9jlV/uQMGMuPu76HSWl3vHILYAjUXNLolU9XpyEFtL8DmLkVbTnHchj2ga/c9vNKNHCSgLdekLVkX0iGzPIG/FcvFCnqaEK0bwCmW8yNXR2r8x2hWD45j/eNwdH+GjM=
Message-ID: <b25c3fa70712122307q88cae7pa6a464d75a27db2@mail.gmail.com>
Date: Thu, 13 Dec 2007 16:07:29 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/7] [NETDEV]: tehuti Fix possible causing oops of net_rx_action
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
In-Reply-To: <20071212.071832.07747779.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <002901c83c73$b089b6e0$9c94fea9@jason>
	 <20071212.071832.07747779.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/13, David Miller <davem@davemloft.net>:
> From: "Joonwoo Park" <joonwpark81@gmail.com>
> Date: Wed, 12 Dec 2007 13:01:27 +0900
>
>
> Any time your trying to make a caller "happy" by adjusting
> a return value forcefully, it's a hack.
>
> And I stated this in another reply about this issue.
>
> Please do not fix the problem this way.
>
> The correct way to fix this is, if we did process a full
> "weight" or work, we should not netif_rx_complete() and
> we should not re-enable chip interrupts.
>
> Instead we should return the true "work_done" value and
> allow the caller to thus poll us one more time.
>

Thanks so much for your advice.
I agree, returning work_done itself exactly.
I will rework for these drivers.

Thanks.
Joonwoo
