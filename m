Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYGIUgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYGIUgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYGIUgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:36:16 -0400
Received: from gw.goop.org ([64.81.55.164]:56594 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYGIUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:36:15 -0400
Message-ID: <4875212E.6090404@goop.org>
Date: Wed, 09 Jul 2008 13:35:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org>	<4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>	<487502FB.3090106@sgi.com> <487507A1.2020100@goop.org> <m1r6a2yfip.fsf@frodo.ebiederm.org>
In-Reply-To: <m1r6a2yfip.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> How does gcc know to use %gs instead of the usual %fs for accessing
> the stack protector variable?  My older gcc-4.1.x on ubuntu always uses %fs.
>   

-mcmodel=kernel

> Or we could do something completely evil.  And use the other segment
> register for the stack canary.
>   

That would still require gcc changes, so it doesn't help much.

    J
