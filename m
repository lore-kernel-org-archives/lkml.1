Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYJPXDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYJPXDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbYJPXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:02:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:44702 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbYJPXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:02:55 -0400
Message-ID: <fa686aa40810161602v16232d96g2eb9af5c063f24f0@mail.gmail.com>
Date: Thu, 16 Oct 2008 17:02:54 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/7] powerpc and sparc: introduce dev_archdata node accessors
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, sfalco@harris.com, khali@linux-fr.org,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20081016.153641.32547403.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	 <20081016171251.GA5515@oksana.dev.rtsoft.ru>
	 <20081016.153641.32547403.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 4:36 PM, David Miller <davem@davemloft.net> wrote:
> From: Anton Vorontsov <avorontsov@ru.mvista.com>
> Date: Thu, 16 Oct 2008 21:12:51 +0400
>
>> The name of the device_node field differ across the platforms, so we
>> have to implement inlined accessors. This is needed to avoid ugly
>> #ifdef in the generic code.
>>
>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>
> I'm happy to just change this member name on sparc to match
> powerpc's choice.
>
> That being said, this abstraction still has value and I'd
> like to let you merge this now and make forward progress
> so:
>
> Acked-by: David S. Miller <davem@davemloft.net>

I agree;

Acked-by: Grant Likely <grant.likely@secretlab.ca>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
