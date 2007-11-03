Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXKCUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXKCUCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbXKCUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:02:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47599 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbXKCUCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:02:13 -0400
Date: Sat, 3 Nov 2007 13:01:54 -0700
From: sukadev@us.ibm.com
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071103200154.GA23234@us.ibm.com>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org> <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com> <472B327E.2060006@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <472B327E.2060006@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| Ulrich Drepper wrote:
| > -----BEGIN PGP SIGNED MESSAGE-----
| > Hash: SHA1
| > 
| > Pavel Emelyanov wrote:
| >>> Isn't it this?
| >>>
| >>> http://lkml.org/lkml/2007/11/1/141
| >> That was the initial problem, and I already answered to Ingo about
| >> it
| > 
| > No, look at my old mail which Ingo referenced in that posting.
| 
| You pointed only one problem that is not a variation of "how do 
| we handle the case when we pass our pid outside the namespace".
| 
| This problem with signals is now being resolved at IBM by Sukadev 
| and Serge (I put them in Cc), so this is about to be fixed by the
| time 2.6.24 releases (I hope).

Yes. We (Oleg, Eric included in Cc) have a patchset to address signals
issues in child pid namespaces. It is being discussed on Containers list:

https://lists.linux-foundation.org/pipermail/containers/2007-October/008240.html

We will post the patchset to LKML soon.

| 
| As far as the "passing the pid outside the namespace" is concerned, 
| is my answer "pids should never be used outside the namespace they
| came from, otherwise userspace won't work as expected" satisfactory?
| 
| So is "everything else", you mentioned, covered with the problems
| above?
| 
| > - --
| > ➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
| > -----BEGIN PGP SIGNATURE-----
| > Version: GnuPG v1.4.7 (GNU/Linux)
| > 
| > iD8DBQFHKy692ijCOnn/RHQRAtYLAJ98EXTGl3HMlCbVXOkL7TJRFfw4DACfcgYI
| > HHz5f7TfM05Dps+ruPRiUrU=
| > =IjS4
| > -----END PGP SIGNATURE-----
| > 
