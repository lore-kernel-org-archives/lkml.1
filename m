Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZGOSwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZGOSwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZGOSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:52:06 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34896 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZGOSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:52:05 -0400
Date: Wed, 15 Jul 2009 20:51:59 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Matt Reimer <mreimer@vpop.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 4/4] ds2760: handle full_active_uAh == 0 case correctly
Message-ID: <20090715185159.GI9464@buzzloop.caiaq.de>
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de> <1247674841-9909-2-git-send-email-daniel@caiaq.de> <1247674841-9909-3-git-send-email-daniel@caiaq.de> <1247674841-9909-4-git-send-email-daniel@caiaq.de> <147B4C9E-4AE2-4FAD-BC58-7D5D905A1B77@vpop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147B4C9E-4AE2-4FAD-BC58-7D5D905A1B77@vpop.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:06:29AM -0700, Matt Reimer wrote:
> On Jul 15, 2009, at 9:20 AM, Daniel Mack wrote:
>
>> In systems where the battery monitor is not part of the battery pack  
>> and
>> is hence not bootstrapped with sane values, the full_active_uAh is
>> likely to be zero.
>>
>> Handle that case by defaulting to the rated_capacity information which
>> can be passed to the driver using the new module parameter.
>>
>> Signed-off-by: Daniel Mack <daniel@caiaq.de>
>> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
>> Cc: Matt Reimer <mreimer@vpop.net>
>> Cc: Anton Vorontsov <cbou@mail.ru>
>
> Acked-by: Matt Reimer <mreimer@vpop.net>

Thanks Matt :) Andrew, will they go thru your channel?

Daniel
