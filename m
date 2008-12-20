Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYLTL4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYLTL4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYLTL4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:56:42 -0500
Received: from karen.lavabit.com ([72.249.41.33]:37068 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYLTL4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:56:42 -0500
X-Greylist: delayed 1723 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Dec 2008 06:56:42 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=lavabit; d=lavabit.com;
  b=y6fy9arR2c9tkb6gHVmQd9C4/WlTCJLm6QrfAlf6eG5DzSt1M/fBLowYaBpmvzZxFG5Dq1C28Czj0j038c62ty8QWvDPKy36V6iwVxPSRaqvzi/ViLYAilKBgIimsYM5OZFYhjIX3B0z2dJkrw1iBX8zsZ4Jg6U8dMxAxXfI20c=;
  h=From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
From: Nanako Shiraishi <nanako3@lavabit.com>
To: Jakub Narebski <jnareb@gmail.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] gitweb local privilege escalation (fix)
Date: Sat, 20 Dec 2008 20:26:48 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Message-Id: <20081220202648.6117@nanako3.lavabit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jakub Narebski <jnareb@gmail.com>:

> Junio C Hamano <gitster@pobox.com> writes:
>
>> Current gitweb has a possible local privilege escalation bug that allows a
>> malicious repository owner to run a command of his choice by specifying
>> diff.external configuration variable in his repository and running a
>> crafted gitweb query.
>> 
>> Recent (post 1.4.3) gitweb itself never generates a link that would result
>> in such a query, and the safest and cleanest fix to this issue is to
>> simply drop the support for it.  Maintenance release v1.6.0.6, v1.5.6.6,
>> v1.5.5.6 and v1.5.4.7 are already available at k.org (see the announcement
>> for v1.6.0.6 I sent out a few minutes ago), and the master branch and
>> others pushed out tonight have the same fix.
>
> From what I have found diff.external works only since v1.5.4 (see
> commit cbe02100), so when gitweb started using git-diff for old
> legacy links to not use $tmpdir and /usr/bin/diff -u it wasn't an
> issue...

Sorry, but I do not understand what you are trying to say.

The maintenance releases Junio listed above go only as far back as v1.5.4.X series, so it covers the necessary range of versions, and no further back than that.  Do you see a problem with that?

-- 
Nanako Shiraishi
http://ivory.ap.teacup.com/nanako3/

