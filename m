Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYHMPeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYHMPeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHMPdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:33:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYHMPdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:33:52 -0400
Message-ID: <48A2FEC2.9000209@zytor.com>
Date: Wed, 13 Aug 2008 08:33:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
References: <20080812224703.GV31439@8bytes.org> <48A2155B.1020904@zytor.com> <20080813080705.GW31439@8bytes.org>
In-Reply-To: <20080813080705.GW31439@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Tue, Aug 12, 2008 at 03:57:31PM -0700, H. Peter Anvin wrote:
>> Right in concept, but I dislike the implementation (duplication of the 
>> CPU detect code we already have).  Could you try this patch and see if 
>> it works for you?
> 
> Cool, with a small modification to fix a build error with it the
> resulting kernel boots my machine. Thanks.
> Would be cool to have this patch one merged soon :-)
> Attached is your patch with my little build fix. It redefines a values
> already defines in cpufeatures.h but I can't include that file in the
> boot code so I simply redeclared it. Maybe there is a cleaner solution
> for this.
> 

There is... let me cook it up and add Alan's correction.

	-hpa
