Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZINDmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZINDmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZINDmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:42:11 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:34996 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbZINDmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:42:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pICDRlgyZyXnaFHxTWWEat+HqzBcKkQFm3VCj3SKEYoqGeyJG4zNveqLxHLOTUEo4I
         Hntp/pCJRVu1eJLE28aImeGOxAPoUgnSIcfMYHqYMRlgeodw931N/ckQ9KF8GkKi7BBi
         imhVIAlIJtXk8XXrUIDnnen04NstR/u7pF4GU=
MIME-Version: 1.0
In-Reply-To: <1243381049-10359-1-git-send-email-vapier@gentoo.org>
References: <1243381049-10359-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 13 Sep 2009 23:41:52 -0400
Message-ID: <8bd0f97a0909132041y3705ff59ja51c7065503ba519@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: add some common Blackfin checks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 19:37, Mike Frysinger wrote:
> Add checks for Blackfin-specific issues that seem to crop up from time to
> time.  In particular, we have helper macros to break a 32bit address into
> the hi/lo parts, and we want to make sure people use the csync/ssync
> variant that includes fun anomaly workarounds.

Andrew: could you pick this up ?
-mike
