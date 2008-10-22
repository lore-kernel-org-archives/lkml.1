Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYJVS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYJVS45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbYJVSxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:53:34 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:53596 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351AbYJVSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=npTaWoPNk2rRv6eNpiaMx4o0DyT974+XV5K1oVuXLl4Cm0x+1tAClWfmX5WRTK9wuh
         +z5p9yCFclIBSQnePsMKXcYH72UHwFvi9alviIiTCXi4SapNjxsZiKG1o3fiJT5cSw3p
         uoFDfl6BmAxorRAqW1+8tNrhi1+Z5R8uXWFoA=
Date: Wed, 22 Oct 2008 22:53:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022185326.GC4218@localhost>
References: <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi> <20081022175827.GL9639@localhost> <Pine.LNX.4.64.0810221110060.27088@quilx.com> <20081022181556.GM9639@localhost> <Pine.LNX.4.64.0810221123150.17454@quilx.com> <20081022184212.GA4218@localhost> <Pine.LNX.4.64.0810221149360.24883@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221149360.24883@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Oct 22, 2008 at 11:49:56AM -0700]
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>
>> I think the patch becomes more complicated as it should be.
>> Maybe just use:
>>
>> #define MAX_OBJ_PER_PAGE 65535 /* since page.objects is u16 */
>
> Ok.
>
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
>

Thanks for review -- will make normal patch shortly and
send it to Pekka. Thanks!

		- Cyrill -
