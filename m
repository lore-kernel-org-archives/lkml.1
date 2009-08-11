Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZHKMDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZHKMDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZHKMDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:03:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:39953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZHKMDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:03:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,359,1246863600"; 
   d="scan'208";a="482492278"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 11 Aug 2009 07:33:57 +0100
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Topic: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Index: AcoZwPH32O+eE+8/TDeninUWmRiuXwAjFfgg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF680@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
 <20090810134608.GA8295@elte.hu>
In-Reply-To: <20090810134608.GA8295@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Monday, August 10, 2009 3:46 PM
>To: Metzger, Markus T
>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: Re: [PATCH] perf_counter: Fix a race on perf_counter_ctx
>
>
>* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>
>> I've been using some old version of perf. When I try to build the
>> version for the latest -tip, I get the following build error:
>>
>> builtin-annotate.o: In function `print_summary':
>> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1211: undefined reference to `rb_first'
>> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1223: undefined reference to `rb_next'
>> builtin-annotate.o: In function `insert_source_line':
>
>Weird. How do you build perf? Do you do:
>
>  cd tools/perf/
>  make
>
>? does your build directory have the ../../lib/rbtree.c file?

Yes and yes.

regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

