Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYGISll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYGISll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYGISld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:41:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYGISlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:41:32 -0400
Message-ID: <48750566.6000500@zytor.com>
Date: Wed, 09 Jul 2008 14:37:26 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org>
In-Reply-To: <487504A8.5040000@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
> 
>> Eh?  Yes they will.  That's the whole point of making the pda a percpu
>> variable itself.  You can use %gs:<small> to get to the pda, and
>> %gs:<larger> to get to percpu variables.  Converting pda->percpu will
>> just have the effect of increasing the %gs offset into the percpu space.
> 
> Right that is what this patchset does.
> 
>> This project isn't interesting to me unless per-cpu variables are
>> directly accessible off %gs.
> 
> Maybe I misunderstood but it seems that you proposed to convert individual members of the pda structure (which uses GS) to per cpu variables (which without this patchset cannot use GS).
> 

I don't understand the "individual members" requirement here.

	-hpa
