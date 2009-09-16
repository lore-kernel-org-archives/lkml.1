Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZIPD4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZIPD4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZIPD4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:56:39 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:40174 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZIPD4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qLC7/vE0rsYkYMGcNsIVRWkbY5CV4su4Yq9ytG1fpsPDhUfIm1UxZGaqBY8R5nHncl
         FXHJRTaO931ORsRcBgYiMf54NX8iluGVD/lL9fzTf9u966fUpBDedIV8frnuegR90X7p
         cqSKVn280g9BSTQ3ZTDZ34ta+4D8sSPC0rtYc=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 23:56:21 -0400
Message-ID: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com>
Subject: Re: 2.6.32 -mm Blackfin patches
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 19:15, Andrew Morton wrote:
> blackfin-convert-to-use-arch_gettimeoffset.patch

i thought John was merging this via some sort of patch series, but i
can pick it up in the Blackfin tree to make sure things are really
sane

> blackfin-fix-read-buffer-overflow.patch

the latter patch i merged into my tree (and i thought that i followed
up in the original posting about this)

> checkpatch-possible-types-else-cannot-start-a-type.patch
> checkpatch-handle-c99-comments-correctly-performance-issue.patch
> checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch
> checkpatch-make-f-alias-file-add-help-more-verbose-help-message.patch
> checkpatch-format-strings-should-not-have-brackets-in-macros.patch
> checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch
> checkpatch-version-029.patch
> checkpatch-add-some-common-blackfin-checks.patch
>
>  Grumpy.  These spit perl warnings but maintainer won't talk to me.

the last one shouldnt cause any warnings at all ;)
-mike
