Return-Path: <linux-kernel-owner+w=401wt.eu-S1763145AbYBSW0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763145AbYBSW0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762701AbYBSW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:26:18 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25909 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762582AbYBSW0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:26:16 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alexn@dsv.su.se" <alexn@dsv.su.se>,
       "dwalker@mvista.com" <dwalker@mvista.com>
Date: Tue, 19 Feb 2008 22:25:00 +0000
Subject: RE: 2.6.25-rc2-mm1: new create_proc_entry() users
Thread-Topic: 2.6.25-rc2-mm1: new create_proc_entry() users
Thread-Index: AchxUv6r7/G4axczTnqrj+Zf8+xEQwB8sVWA
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE0427C1CB86@G6W0268.americas.hpqcorp.net>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
 <20080217105050.GC6596@martell.zuzino.mipt.ru>
In-Reply-To: <20080217105050.GC6596@martell.zuzino.mipt.ru>
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



> -----Original Message-----
> From: Alexey Dobriyan [mailto:adobriyan@gmail.com]
> Sent: Sunday, February 17, 2008 4:51 AM
> To: Andrew Morton
> Cc: linux-kernel@vger.kernel.org; Miller, Mike (OS Dev);
> alexn@dsv.su.se; dwalker@mvista.com
> Subject: 2.6.25-rc2-mm1: new create_proc_entry() users
>
> > profile-likely-unlikely-macros
> > page-owner-tracking-leak-detector
> > cciss-procfs-updates-to-display-info-about-many-volumes
>
> Guys, create_proc_entry() is slightly racy in case of modular code and
> proc_create() was invented to fix it. Eventually all
> create_proc_entry() users will be converted to proc_create(),
> so please do it for new code.
>
Why am I getting "implicit declaration of function 'proc_create'" when I try to use that function? I have kernel version 2.6.24, gcc version 4.1.1 20070105 (Red Hat 4.1.1-51). Am I missing a header file?

-- mikem
