Return-Path: <linux-kernel-owner+w=401wt.eu-S936344AbYCSVJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936344AbYCSVJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761771AbYCST7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48571 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761758AbYCST7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:05 -0400
Date: Tue, 18 Mar 2008 22:48:49 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not allow setting of quota limits to too high
 values
In-Reply-To: <20080318164410.GR23104@duck.suse.cz>
Message-ID: <alpine.LNX.1.00.0803182248390.8851@fbirervta.pbzchgretzou.qr>
References: <20080312172255.GB21395@duck.suse.cz> <20080313130355.6a84d0c5.akpm@linux-foundation.org> <20080317131138.GA17307@duck.suse.cz> <alpine.LNX.1.00.0803181740300.8851@fbirervta.pbzchgretzou.qr> <20080318164410.GR23104@duck.suse.cz>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18 2008 17:44, Jan Kara wrote:
>>>>
>>>> For 2.6.26, I assume?  I am not able to determine the seriousness of this
>>>> problem from the changelog nor from the patch itself.
>>>
>>>  Not really serious. Nobody complained so far (i.e., for the time quota
>>> exists) and the limits will just wrap when you try to set them over 4TB
>>> now. So the patch can wait...
>> So does quota_v2.c even handle quotas > 4 TB?
>  Usage yes, limits no. But some Sun guys are already working on a patch
> for fully 64-bit quota. I already have a decent kernel patch from him but
> I'd like to see also tools support to really run it before merging the
> patch :).

Does this also affect XFS?
