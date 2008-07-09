Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYGIVU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYGIVU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGIVUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:20:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYGIVUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:20:49 -0400
Message-ID: <48752AC2.7080700@zytor.com>
Date: Wed, 09 Jul 2008 17:16:50 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org>	<4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>	<487502FB.3090106@sgi.com> <487507A1.2020100@goop.org>	<m1r6a2yfip.fsf@frodo.ebiederm.org> <4875212E.6090404@goop.org> <m18wwavkxz.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wwavkxz.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
>>> Or we could do something completely evil.  And use the other segment
>>> register for the stack canary.
>>>
>> That would still require gcc changes, so it doesn't help much.
> 
> We could use %fs for the per cpu variables.  Then we could set %gs to whatever
> we wanted to sync up with gcc

No swapfs instruction, and extra performance penalty because %fs is used 
  in userspace.

	-hpa
