Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYGISf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYGISf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGISfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:35:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbYGISfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:35:13 -0400
Message-ID: <487504A8.5040000@linux-foundation.org>
Date: Wed, 09 Jul 2008 13:34:16 -0500
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
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org>
In-Reply-To: <487502BD.2020206@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> Eh?  Yes they will.  That's the whole point of making the pda a percpu
> variable itself.  You can use %gs:<small> to get to the pda, and
> %gs:<larger> to get to percpu variables.  Converting pda->percpu will
> just have the effect of increasing the %gs offset into the percpu space.

Right that is what this patchset does.

> This project isn't interesting to me unless per-cpu variables are
> directly accessible off %gs.

Maybe I misunderstood but it seems that you proposed to convert individual members of the pda structure (which uses GS) to per cpu variables (which without this patchset cannot use GS).

