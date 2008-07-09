Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYGISfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYGISfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYGISfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:35:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYGISfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:35:33 -0400
Message-ID: <48750401.9080103@zytor.com>
Date: Wed, 09 Jul 2008 14:31:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>
In-Reply-To: <4874FFC4.7050505@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Mike Travis wrote:
> 
>> I think Jeremy's point is that by removing the pda struct entirely, the
>> references to the fields can be the same for both x86_32 and x86_64.
> 
> That is going to be difficult. The GS register is tied up for the pda area
> as long as you have it. And you cannot get rid of the pda because of the library
> compatibility issues. We would break binary compatibility if we would get rid of the pda.
> 

We're talking about the kernel here... who gives a hoot about binary 
compatibility?

	-hpa

