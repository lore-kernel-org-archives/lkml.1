Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247AbZJGEKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbZJGEKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZJGEKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:10:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52497 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZJGEKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:10:11 -0400
Message-Id: <200910070409.n9749OQ1092174@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #16 00/25] Starting TOMOYO 2.3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: pavel@ucw.cz
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Oct 2009 13:09:24 +0900
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091006093922.GB1363@ucw.cz>
In-Reply-To: <20091006093922.GB1363@ucw.cz>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 07102009 #2708572, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Pavel Machek wrote:
>> Since this patchset is not yet accepted, I haven't written documentation for
>> TOMOYO 2.3. You can see http://tomoyo.sourceforge.jp/1.7/policy-reference.html
>> instead.
>
>New, undocumented user/kernel api is no-no.

I'll update api description by final submission.

Main purpose of this submission is to

(1) know whether 01, 02, 03, 05 and 06 are acceptable or not.
    If 05 is not acceptable, the rest of patchset needs to be rewritten.
    Please review 01, 02, 03, 05 and 06 before reviewing the rest.

(2) know which features are acceptable.
    This submission includes proposal of new features.

      Use of customized d_path().
      Network filtering including incoming TCP connections.
      Audit logs.
      Conditional permissions.
      Interactive enforcing mode.
      Sleep penalty.
      Execute handler.
      Environment variable name checking.
      Non POSIX capability checking.

    Unacceptable features will be dropped from next submission.

>> Conventionally, patches should be submitted in the form of diff file.
>> But this time, I submit in the form of entire file due to amount of changes.
>
> That's also no-no.

I have a question.
Is the diff file based on existing files more preferable for reviewers to
review than totally rewritten files, even if "total lines of diff files" is
close to "total lines of rewritten files"?

Amount of rewritten files:
# cat security/tomoyo/* | wc -l
17250

Amount of diff based on existing files:
# diff -Nur security/tomoyo.2.2/ security/tomoyo/ | wc -l
16945
# diff -Nur security/tomoyo.2.2/ security/tomoyo/ | diffstat -f0
 24 files changed, 13495 insertions(+), 2216 deletions(-)

I posted rewritten files because I thought reading 17250 insertions is less
difficult than reading 16945 lines of diff file with complicated mixture of
13495 insertions and 2216 deletions.

Regards.
