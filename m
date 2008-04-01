Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYDAJAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYDAJAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYDAJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:00:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:19396 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbYDAJAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EY3BTLvqJ8S2DvcRXlMw2Gwqp1OnO7m5BbPv+GXFLJpbt8veJ59nPB4ngeFnhhuR8O131twsHNMf2Fgn7VukJFOR5Fs8aOx1DahVGpCfbuN2moavHwwkP+vE1x7YkVf1NdgkQbqzzeiI24h+jUkwtZegyKkbcgCYy+HDeaP3RC8=
Message-ID: <84144f020804010200k759b342dy7a7da1d7f86e22ec@mail.gmail.com>
Date: Tue, 1 Apr 2008 12:00:39 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: Artem.Bityutskiy@nokia.com
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
Cc: "Artem Bityutskiy" <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <47F1F33A.1020909@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com>
	 <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com>
	 <47F1D44A.8010908@yandex.ru> <47F1E534.7050803@cs.helsinki.fi>
	 <47F1F33A.1020909@nokia.com>
X-Google-Sender-Auth: c3deedf92af094aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Tue, Apr 1, 2008 at 11:32 AM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
>  I am not sure what you mean. I would not want to delve into a general
>  discussion of the debugging stuff. I would better talk about specific
>  things. I'll just point you examples of debugging stuff in the kernel
>  in other subsystems which exists and does not hurt anyone. And I believe
>  it is helpful. It is compiled out by default and is enable when it is
>  needed to hunt a bug.
>
>  fs/ext2: ea_idebug(), EXT2FS_DEBUG
>  fs/xfs: #ifdef DEBUG, XFS_LOUD_RECOVERY and so on
>  fs/ocfs2: OCFS2_DEBUG_FS
>  fs/jfs: CONFIG_JFS_DEBUG, assert(), etc
>  fs: DEBUG_EPOLL, #ifdef DEBUG
>  fs/jbd2: assert_spin_locked(), CONFIG_JBD2_DEBUG, etc
>  mm: CONFIG_SLUB_DEBUG, SLABDEBUG, CONFIG_DEBUG_VM, and so on

But they're totally different kind of thing! They're not for disabling
hundreds of debug-only printks sprinkled around the kernel. Instead,
they let you disable well-defined debugging checks for kernel speed
and/or size optimizations. And btw, CONFIG_SLUB_DEBUG is only a kernel
size optimization for CONFIG_EMBEDDED. The SLUB debugging code can be
turned on and off at run-time.

                       Pekka
