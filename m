Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZIXVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZIXVHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIXVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZIXVHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:07:22 -0400
Message-ID: <4ABBDF77.3090106@redhat.com>
Date: Thu, 24 Sep 2009 14:07:03 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: Dont use openat()
References: <4ABB6EB7.7000002@gmail.com> <20090924131250.GA15132@elte.hu> <4ABB767D.6080004@gmail.com>
In-Reply-To: <4ABB767D.6080004@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
>> We can certainly remove that reliance - wanna send a patch for it?

Come on, the silliness has to stop.  The kernel must be recent and to
use it adequately the C library also must be recent.  And "recent" is
not even correct anymore: the functions are available for more then two
years.  Removing the use of the modern interfaces makes everything
slower and might even re-introduce race conditions my patch fixed.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkq733cACgkQ2ijCOnn/RHQHzQCgsmre/xVEVghMVRWDCIevMPwc
+ecAmwaSOSLuSySZXRzSY/S64jf7K0Bd
=y6MN
-----END PGP SIGNATURE-----
