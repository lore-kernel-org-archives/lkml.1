Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYGITpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYGITpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYGIToz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:44:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbYGIToz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:44:55 -0400
Message-ID: <48751513.9050202@linux-foundation.org>
Date: Wed, 09 Jul 2008 14:44:19 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org>
In-Reply-To: <4875123F.1070504@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> Yes, I understand that, but it's still pointless churn.  The
> intermediate step is no improvement over what was there before, and
> isn't any closer to the desired final result.

No its not pointless churn. We actually eliminate all the pda operations and use the per_cpu operations both on 32 and 64 bit. That is unification.

We would be glad if you could contribute the patches to get rid of the pda.xxx references. I do not think that either Mike or I have the 32 bit expertise needed to do that step. We went as far as we could. The patches are touching all the points of interest so locating the lines to fix should be easy.




