Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbYETBN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbYETBN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYETBNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:13:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45436 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764266AbYETBNL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:13:11 -0400
From: Alok Kataria <akataria@vmware.com>
To: Jan Engelhardt <jengelh@medozas.de>
CC: "penguin-kernel@i-love.sakura.ne.jp" 
	<penguin-kernel@i-love.sakura.ne.jp>,
       "devzero@web.de" <devzero@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Date: Mon, 19 May 2008 18:08:56 -0700
Subject: RE: Kernel hangs in SMP + VMware environment.
Thread-Topic: Kernel hangs in SMP + VMware environment.
Thread-Index: Aci5H8kN1cGhJlwgSwWu8C0qIPIx2AA9kryD
Message-ID: <D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E8@PA-EXMBX04.vmware.com>
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>,<alpine.LNX.1.10.0805182145010.15590@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805182145010.15590@fbirervta.pbzchgretzou.qr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

________________________________________
From: jengelh@sovereign.computergmbh.de [jengelh@sovereign.computergmbh.de] On Behalf Of Jan Engelhardt [jengelh@medozas.de]
Sent: Sunday, May 18, 2008 12:45 PM
To: Alok Kataria
Cc: penguin-kernel@i-love.sakura.ne.jp; devzero@web.de; linux-kernel@vger.kernel.org; Daniel Hecht
Subject: Re: Kernel hangs in SMP + VMware environment.

On Wednesday 2008-05-14 20:30, Alok Kataria wrote:
>On Wed, May 14, 2008 at 4:00 AM, Tetsuo Handa
><penguin-kernel@i-love.sakura.ne.jp> wrote:
>> Hello.
>>
>> Roland wrote:
>>> maybe related to http://bugzilla.kernel.org/show_bug.cgi?id=9834  ?
>> Thank you for URL.
>> My bug seems to be timer related.

I too noticed it; clocksource=pit is my current workaround.

ANK> What kernel do you see this with ? Did you get a a chance to try the patch
ANK> which I sent earlier on this thread ?


>>> you say "recent" , so this does happen from 2.6.21 to 2.6.26rc2 ?
>
>> I don't know exact version, but I don't experience this problem
>> in earlier kernels (e.g. Fedora Core 5 which uses kernel 2.6.20).

It does not happen for 2.6.23, and IIRC it did not with 2.6.24
either; 2.6.25-rcish is the first to show this behavior.

ANK> Are you sure you didn't see it with 2.6.23/2.6.24 ?
ANK> i am assuming your test case is also similar to that of Tetsuo.
ANK> Multiple guests running simoultaneously.

Oh well, time to bisect.

ANK> Let me know if you get anything their.


Thanks,
Alok
