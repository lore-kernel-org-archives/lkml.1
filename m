Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYFRWcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYFRWcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYFRWcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:32:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:12175 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbYFRWcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TGBADPsfrxk/f4uNBzs+U+gQ+deZHFkcP9Fz5kjCa0dH96ZIgzmU34sfiwYTYMRnqv
         oQcZwF+qHYeVOL9bISF5ETZrti1n+sP0Po6mUYuQCTCZBMpAZDhZN8Q6hHCRZXpw2dyT
         k3VWj4est3qB/TYfxt1cQI1B5C9pUiqlqoSs4=
Message-ID: <9929d2390806181532ub067a64y74b6315f1bd68375@mail.gmail.com>
Date: Wed, 18 Jun 2008 15:32:00 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] [UPDATED] ixgbe: add LRO support
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       randy.dunlap@oracle.com
In-Reply-To: <48588933.2060605@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613183716.9641.33945.stgit@localhost.localdomain>
	 <48588933.2060605@garzik.org>
X-Google-Sender-Auth: 4dce277c614e2b30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 9:04 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> I take that back.
>
> This patch has a bunch of checkpatch problems, and it doesn't even compile,
> so it obviously was not tested:
>
> drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_receive_skb':
> drivers/net/ixgbe/ixgbe_main.c:416: error: implicit declaration of function
> 'vlan_nw_accel_receive_skb'
>
> --

My apologies, in the last update, the patch got altered in my tree.  I
will re-send the corrected patch which has been tested.

-- 
Cheers,
Jeff
