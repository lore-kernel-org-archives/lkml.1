Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbYGYPtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbYGYPtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYGYPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:49:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36979 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750807AbYGYPtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:49:16 -0400
Message-ID: <4889F5FA.1050908@sgi.com>
Date: Fri, 25 Jul 2008 08:49:14 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org>
In-Reply-To: <4874F909.7060503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Did the suspected linker bug issue ever get resolved?
> 
> I don't believe so.  I think Mike is getting very early crashes
> depending on some combination of gcc, linker and kernel config.  Or
> something.
> 
> This fragility makes me very nervous.  It seems hard enough to get this
> stuff working with current tools; making it work over the whole range of
> supported tools looks like its going to be hard.
> 
>    J

FYI, I think it was a combination of errors that was causing my problems.
In any case, I've successfully compiled and booted Ingo's pesky config
config-Tue_Jul__1_16_48_45_CEST_2008.bad with gcc's 4.2.0, 4.2.3 and 4.2.4
on both Intel and AMD boxes.  (As well as a variety of other configs.)

I think Hugh's change adding "text" to the BUILD_IRQ macro might also have
helped, since interrupts seemed to have always been involved in the panics.
That might explain the variable-ness of the gcc version's.

Thanks,
Mike
