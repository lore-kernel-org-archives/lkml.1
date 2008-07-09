Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYGIScJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYGIScJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYGISb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:31:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32994 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbYGISb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:31:57 -0400
Message-ID: <4875041C.60206@sgi.com>
Date: Wed, 09 Jul 2008 11:31:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FAB2.5080401@goop.org> <4875000A.3060004@sgi.com> <48750202.3060603@goop.org>
In-Reply-To: <48750202.3060603@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
...
> The trouble with reusing the space is that it's going to be things like
> "current" which are the best candidates for going there - but if you do
> that you lose i386 unification (unless you play some tricks where you
> arrange to make the percpu variables land there while still appearing to
> be normal percpu vars).
> 
>    J


One more approach... ;-)  Once the pda and percpu vars are in the same
area, then could the pda be used for both 32 and 64...?
