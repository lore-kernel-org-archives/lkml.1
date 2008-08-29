Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYH2HbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYH2HbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYH2Hax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:30:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36435 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYH2Hax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:30:53 -0400
Date: Fri, 29 Aug 2008 09:30:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
	corruption
Message-ID: <20080829073036.GB9232@elte.hu>
References: <48B701FB.2020905@goop.org> <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com> <20080829064540.GA26619@elte.hu> <48B7A377.8010205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48B7A377.8010205@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rafał's corruption was definitely non-zero.  I think the corruption is 
> happening, but it's just not reported.

i thought we did a check after coming back from resume? That would be a 
natural place to do the check. (the corruption is suspend/resume related 
after all, right?)

	Ingo
