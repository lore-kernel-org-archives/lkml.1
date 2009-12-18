Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZLRHPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZLRHPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZLRHPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:15:12 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33695 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZLRHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=IgoCg3T24zFdBZhJ8iziF51seUH1pNUbHvxGUgLuqvs2yzT4R5ullu6jFDeEUvT0+9
         hYz+G4sgQW+aETicK1MDNmlvA0gYOmYHIp2fqGD+2OG1DgIO0MZsutkqPzxOwW22ifMp
         BElQhtz1YPcZvqZOJzQvk/9ODI9dtNf+eVNQ4=
MIME-Version: 1.0
Date: Fri, 18 Dec 2009 02:15:09 -0500
Message-ID: <b4198de60912172315w73223eh996d32c89ac807fd@mail.gmail.com>
Subject: [PULL] alpha-2.6
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git
for-linus

It contains some catch-up work, adding missing syscalls and perf
support, along with the new unreachable() stuff.

Thanks,
Matt Turner

The following changes since commit 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f:
  Linus Torvalds (1):
        Linux 2.6.33-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git for-linus

Daniele Calore (1):
      alpha: Wire up missing/new syscalls

David Daney (1):
      alpha: Convert BUG() to use unreachable()

Michael Cree (1):
      alpha: Add minimal support for software performance events

 arch/alpha/Kconfig                  |    1 +
 arch/alpha/include/asm/bug.h        |    3 ++-
 arch/alpha/include/asm/perf_event.h |    9 +++++++++
 arch/alpha/include/asm/unistd.h     |   17 ++++++++++++++++-
 arch/alpha/kernel/systbls.S         |   16 +++++++++++++++-
 5 files changed, 43 insertions(+), 3 deletions(-)
 create mode 100644 arch/alpha/include/asm/perf_event.h
