Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZLSUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZLSUDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 15:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZLSUDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 15:03:47 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:57376 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZLSUDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 15:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LjocuRPRU+LczPraefndc72S6pCK1Jr712thv1bLo0ycfBDIZxxAUqfkht4UpCUxMR
         1Pe/MGnLkckCsEbaoNwlHK2on1srgmOMlUdCLADaQ03vMX9+Xw2d0wnDeWffrIMcJsWZ
         WoEciXbMBuQ4xnkel1X33kaemI7WocBkuxy3E=
MIME-Version: 1.0
In-Reply-To: <b4198de60912172315w73223eh996d32c89ac807fd@mail.gmail.com>
References: <b4198de60912172315w73223eh996d32c89ac807fd@mail.gmail.com>
Date: Sat, 19 Dec 2009 15:03:45 -0500
Message-ID: <b4198de60912191203s2fa8d0cfpe0db59c8c8f42fa5@mail.gmail.com>
Subject: Re: [PULL] alpha-2.6
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 2:15 AM, Matt Turner <mattst88@gmail.com> wrote:
> Hi Linus,
>
> Please pull the 'for-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git
> for-linus
>
> It contains some catch-up work, adding missing syscalls and perf
> support, along with the new unreachable() stuff.

Ping?

I read your -rc1 announcement and assumed this pull request was one of
the ones you were talking about.

The changes are very basic, but are nonetheless pretty important.
(latest udev doesn't run without the added inotify_init1 syscall).

> Thanks,
> Matt Turner
>
> The following changes since commit 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f:
>  Linus Torvalds (1):
>        Linux 2.6.33-rc1
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git for-linus
>
> Daniele Calore (1):
>      alpha: Wire up missing/new syscalls
>
> David Daney (1):
>      alpha: Convert BUG() to use unreachable()
>
> Michael Cree (1):
>      alpha: Add minimal support for software performance events
>
>  arch/alpha/Kconfig                  |    1 +
>  arch/alpha/include/asm/bug.h        |    3 ++-
>  arch/alpha/include/asm/perf_event.h |    9 +++++++++
>  arch/alpha/include/asm/unistd.h     |   17 ++++++++++++++++-
>  arch/alpha/kernel/systbls.S         |   16 +++++++++++++++-
>  5 files changed, 43 insertions(+), 3 deletions(-)
>  create mode 100644 arch/alpha/include/asm/perf_event.h
>
