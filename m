Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYJVS4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYJVS4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYJVSwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:52:44 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:62284 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbYJVSwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZKXLJLoN1WoWz/hhsiCT2GSYN7eDg0P2GjBPzSAb41DZX9MZRlmpGOCL9RuHN+uO+g
         Zhs3JMWtF9p+wGw8gEvGkz9zOpEiofRi6T6aA+JUGffVkJivRAbZz5qzb6PliHjN2YWE
         Y+k0YDLeLz/Uz8Zu0CRT6SKHAtsboDEKg93pQ=
Date: Wed, 22 Oct 2008 22:52:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022185237.GB4218@localhost>
References: <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi> <20081022175827.GL9639@localhost> <Pine.LNX.4.64.0810221110060.27088@quilx.com> <20081022181556.GM9639@localhost> <Pine.LNX.4.64.0810221123150.17454@quilx.com> <20081022183055.GN9639@localhost> <Pine.LNX.4.64.0810221144290.6054@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221144290.6054@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Oct 22, 2008 at 11:45:55AM -0700]
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>
>> Looks really good for me (if it worth anything). But Christoph
>> doesn't OO_SHIT inspired by u16 too which means we could use
>> MAX_OBJ_PER_PAGE in form you mentoined but maybe we should define
>>
>> #define OO_SHIFT bits_in(page.objects) to point out why we use
>> 16 not 14, not 18 or whatever? How do you think?
>
>
> The choice of the bit size in page.objects is determined by the available 
> bytes there. The choice of the OO_SHIFT (nice typo there) is determined 
> by the use of a 32bit int that we want to cut into two halves.
>

Ah... I see. So wouldn't you mind to just mentoin page.objects in comment
like 'since page.objects is u16' instead of bits_in magic? Anyone who
will (if any) changing page structure is to grep the sources and find
this comment and will fix MAX_OBJS_PER_PAGE definition.

		- Cyrill -
