Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbYJMNfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbYJMNfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYJMNe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:34:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:19130 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbYJMNez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=yHeVpiDWRSTtGWO5konKYtG7Jc666evHNCAvlENeKea4BM9I0AV9QkowH54pkwNaeb
         jB6Caoh5n2ouCj47YvyJBnQbvW9dkaMVUgpTKXOilmyg+lFYih/xxYSXSIObF/kxtupO
         z8FfcAEgH69QNNheJbs+zW0Cjz6F0gpnlq24E=
Message-ID: <7c86c4470810130634v28daf6e1u50f3e76fcc432e4c@mail.gmail.com>
Date: Mon, 13 Oct 2008 15:34:52 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: 2.6.27 perfmon patch, new version of libpfm, pfmon available
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have released the perfmon2 kernel patch for kernel v2.6.27. There is
no major features. Interface version is not at v2.82 following a small
addition to the sysfs admin interface.

Here are the new features for the kernel:
  - Support for Intel Atom processors, including PEBS
  - preliminary support for Intel E74xx (Dunnington), including PEBS
  - /sys/kernel/perfmon/mode, new configuration option for the interface
  - list of available pmc/pmd reported by context

There is also a new release for libpfm, now at version 3.6.
The changes include:
  - Support for Intel Atom processors
  - preliminary support for Intel E74xx (Dunnington)

Finally, a new version of pfmon, v3.5, with:
  - Support for Intel Atom processors
  - preliminary support for Intel E74xx (Dunnington)
  - lots of code cleanups and bug fixes

Concerning the merge, we have been making a lot of progress in the
redesign of the syscall API to minimize the number of syscalls and
make each one easier to extend, should this be needed. We are
now down to 7 syscalls for the full interface, down from 12. The
experimental kernel code is available in the GIT repository in
the 'perfmon3' branch. Similarly, there is a matching perfmon3
branch of libpfm, with all examples updated. This verison of
the library also provides the glue layer so that each v2.82
perfmon2 application can continue to work unmodified.

The minimal kernel patchset has also been updated to reflect the
new syscalls API. It will be posted on LKML shortly. As a reminder,
this quilt patchset provides only per-thread counting on Intel and
AMD X86 processors. It is meant to serve as the base upon which the
rest of the perfmon2 API can be gradually added.

As usual all files and more detailed changelogs can be downloaded from
our website at:

        http://perfmon2.sourceforge.net

Enjoy,
