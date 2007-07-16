Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXGPVFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXGPVFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbXGPVFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:05:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:28488 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbXGPVFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GWpi5JL9eWZbmYGxp5sqNk6AUKSgLLmPupoT9YrPnTj/Mwkr7+QUwQUsDVR5TUlGc0hNvaC9peN8P51pAw6GCFcldD1KKQInJW18yC6PADS10OI60KFsZQjV1I8hJhfgPXmijFn9BaKWlNUE3+qLDmmP7g/+RkXmdk8RID57KZI=
Message-ID: <4d8e3fd30707161404u49108231kae05aa80180a8857@mail.gmail.com>
Date: Mon, 16 Jul 2007 23:04:58 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Linux Kernel Development
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm the author of the document "Introduction to Linux Kernel
Development Process" hosted at
http://linux.tar.bz/articles/2.6-development_process.
Part of the document has been included in Documentation/HOWTO

I was reading  both the documents while I started, again, to think
about how to improve the quality of the vanilla kernels.

Here are a few line of the document I wrote:

---8<------8<------8<------8<------8<------8<------8<------8<------8<---
 --- 2.6.x kernels ---

2.6.x kernels are maintained by Linus Torvalds,
it's development is as follow:
- As soon a new kernel is released a two weeks windows is open, during
  this period of time maintainers can submit big diffs to Linus, usually
  the patched sited in -mm kernels for a few weeks.
  Preferred way to submit big changes is using GIT
  (more information about GIT at http://git.or.cz/ and
  http://www.kernel.org/pub/software/scm/git/docs/tutorial.html).
- After two weeks a -rc1 kernel is released and now is possible to
  push only patches that do not include new functionalities that could
  affect the stability of the whole kernel. Please note that a whole
  new driver (or filesystem) might be accepted
  after -rc1 because there is no risk of causing regressions with
  such a change
- A new -rc is released whenever Linus deems the current git
 (the kernel's source management) tree to be in a reasonably sane state
  adequate for testing. The goal is to release a new -rc kernel every week.
- Process continues until the kernel is considered "ready", the
  process should last around 6 weeks ( 6 kernels per year should be
  released) an usually includes 4/5 rc releases.
---8<------8<------8<------8<------8<------8<------8<------8<------8<---

The sentence "Process continues until the kernel is considered "ready"
" should probably be changed in order to reflect the usage of the
"regression list" that Adrian and then Michal were used to maintain.

Is there a "stable" place were users can read/comment/modify the list?
Wasn't Google interested in employee a person to take care of
regression/bug report? (Yes, if there is an open position I would be
interested in applying ;-).

Thanks!

Regards,
-- 
Paolo
