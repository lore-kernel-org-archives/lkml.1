Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZKMHXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZKMHXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZKMHXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:23:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:61716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbZKMHXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:23:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,734,1249282800"; 
   d="scan'208";a="513452288"
From: "Ma, Ling" <ling.ma@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Pavel Machek <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 13 Nov 2009 15:23:13 +0800
Subject: RE: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Topic: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Index: AcpkJ0FFKUUYTQHHSVCdhlBX0uQM6gACha4A
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FEB071DF@PDSMSX501.ccr.corp.intel.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <20091112121604.GC1394@ucw.cz>
 <8FED46E8A9CA574792FC7AACAC38FE7714FEB070EE@PDSMSX501.ccr.corp.intel.com>
 <4AFCF6D6.6040607@zytor.com>
In-Reply-To: <4AFCF6D6.6040607@zytor.com>
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

Hi H. Peter Anvin
>What it sounds to me is that for Nehalem, we want to use memcpy_c for >=
>1024 bytes and the old code for < 1024 bytes;

Yes, so we modify memcpy_c as memcpy_new for Nehalem, and keep old
code for Core2 is acceptable?

Thanks
Ling

