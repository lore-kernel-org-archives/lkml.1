Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXFUUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXFUUXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXFUUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:23:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:39319 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbXFUUXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=uR4msuOgMfcuoLkyhGA6rMvn4JQJ3FXLlLCgpfVue2L2PR1Sp9P2+3g/e+ueeJMbcw5t7d12a2IpqIRhIZgf0HMRLaCLbmSueKd96RfVM8o9JWfCFkXW7DqBNbBe1E6b5+lMI1u2DIHIWISZ13cUUwf0SU769v/SqIhhYQKIctE=
Message-ID: <467ADE12.7020303@googlemail.com>
Date: Thu, 21 Jun 2007 22:22:42 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>,
       =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches v2
References: <467AA8CA.2020206@googlemail.com> <alpine.LFD.0.98.0706211115380.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706211115380.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds pisze:
> 
> On Thu, 21 Jun 2007, Michal Piotrowski wrote:
>> Subject    : long freezes on thinkpad t60
>> References : http://lkml.org/lkml/2007/5/24/100
>> Submitter  : Miklos Szeredi <miklos@szeredi.hu>
>> Handled-By : Ingo Molnar <mingo@elte.hu>
>> Patch      : http://lkml.org/lkml/2007/6/16/81
>> Status     : patch was suggested
> 
> This one is fixed, and tested by Miklos. It's commit fa490cfd15: "Fix 
> possible runqueue lock starvation in wait_task_inactive()".

Thanks for the information.

BTW. Björn noticed that I accidentally removed this regression.

Subject    : OProfile issues
References : http://lkml.org/lkml/2007/6/12/207
Submitter  : Stephane Eranian <eranian@hpl.hp.com>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/6/12/392
Status     : patch was suggested


Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
