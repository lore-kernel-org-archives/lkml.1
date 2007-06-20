Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXFTJh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXFTJh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbXFTJhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:37:50 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:63101 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753228AbXFTJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:37:49 -0400
Date: Wed, 20 Jun 2007 11:38:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] I2C: TSL2550 support.
Message-ID: <20070620113842.03635603@hyperion.delvare>
In-Reply-To: <20070619144845.GJ4374@enneenne.com>
References: <5d5443650706190428q341a50a1obae68b2565d0ed7@mail.gmail.com>
	<20070619121020.GA8902@enneenne.com>
	<20070619153940.0e120fb0@hyperion.delvare>
	<20070619144845.GJ4374@enneenne.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,

On Tue, 19 Jun 2007 16:48:46 +0200, Rodolfo Giometti wrote:
> Please, note that I left LUX calculation untouched since on my data
> sheet I have only such cumputation example. :(
> 
> Hope it could be ok anyway...

Datasheets typically give you one way to process the data, that doesn't
mean this is the only way, nor the best in all situations. My proposal
was mathematically equivalent to your datasheet-based implementation,
and had a lower memory footprint.

Anyway, your way works too, so it's OK. I'll take your patch as is,
optimizations can always be applied later. I wish I could give a try to
your driver, but unfortunately I still didn't manage to get my TAOS
evaluation module to work under Linux :(

-- 
Jean Delvare
