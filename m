Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbYCSVJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbYCSVJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760333AbYCST7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:52772 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761752AbYCST7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:02 -0400
Date: Wed, 19 Mar 2008 10:54:42 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not allow setting of quota limits to too high values
Message-ID: <20080319095442.GA22109@duck.suse.cz>
References: <20080312172255.GB21395@duck.suse.cz> <20080313130355.6a84d0c5.akpm@linux-foundation.org> <20080317131138.GA17307@duck.suse.cz> <alpine.LNX.1.00.0803181740300.8851@fbirervta.pbzchgretzou.qr> <20080318164410.GR23104@duck.suse.cz> <alpine.LNX.1.00.0803182248390.8851@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0803182248390.8851@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-03-08 22:48:49, Jan Engelhardt wrote:
>
> On Mar 18 2008 17:44, Jan Kara wrote:
>>>>>
>>>>> For 2.6.26, I assume?  I am not able to determine the seriousness of 
>>>>> this
>>>>> problem from the changelog nor from the patch itself.
>>>>
>>>>  Not really serious. Nobody complained so far (i.e., for the time quota
>>>> exists) and the limits will just wrap when you try to set them over 4TB
>>>> now. So the patch can wait...
>>> So does quota_v2.c even handle quotas > 4 TB?
>>  Usage yes, limits no. But some Sun guys are already working on a patch
>> for fully 64-bit quota. I already have a decent kernel patch from him but
>> I'd like to see also tools support to really run it before merging the
>> patch :).
>
> Does this also affect XFS?
  No. All XFS quotas have in common with VFS quotas is the name of the
syscall (quotactl()). All the rest is different and XFS has everywhere
64-bit fields.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
