Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYGIRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYGIRqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYGIRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:46:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYGIRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:46:17 -0400
Message-ID: <4874F890.5060008@zytor.com>
Date: Wed, 09 Jul 2008 13:42:40 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F7F2.6050108@sgi.com>
In-Reply-To: <4874F7F2.6050108@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> H. Peter Anvin wrote:
>> Hi Mike,
>>
>> Did the suspected linker bug issue ever get resolved?
>>
>>     -hpa
> 
> Hi Peter,
> 
> I was not able to figure out how the two versions of the same
> kernel compiled by gcc-4.2.0 and gcc-4.2.4 differed.   Currently,
> I'm sticking with gcc-4.2.4 as it boots much farther.
> 
> There still is a problem where if I bump THREAD_ORDER, the
> problem goes away and everything so far that I've tested boots
> up fine.
> 
> We tried to install a later gcc (4.3.1) that might have the
> "GCC_HAS_SP" flag but our sys admin reported:
> 
> 	The 4.3.1 version gives me errors on the make.  I had to
> 	pre-install gmp and mpfr, but, I still get errors on the make.
> 
> I think that was the latest he found on the GNU/GCC site.
> 

We have seen miscompilations with gcc 4.3.0 at least; not sure about 4.3.1.

	-hpa

