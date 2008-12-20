Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYLTKyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYLTKyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 05:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYLTKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 05:54:29 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:45873 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYLTKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 05:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:in-reply-to
         :message-id:lines:user-agent:mime-version:content-type:date;
        b=iDgXu8Fj2mDaPcEeig7BcmMAlnJCO9TixCp0BlOUo5lDDAmyG14WF4FWHM/2ezpSO2
         r2NxGkQFhsK9TkknQZaFvTm+dnEcN56mdYPp1IGvq5HKKq7Mb6eSrf56Kt5riCCM9gAP
         zVLM410Xfi64ph9Mr169nQB/56kjwqFfFab5Q=
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] gitweb local privilege escalation (fix)
References: <7vljub1h92.fsf@gitster.siamese.dyndns.org>
	<7vhc4z1gys.fsf@gitster.siamese.dyndns.org>
From: Jakub Narebski <jnareb@gmail.com>
In-Reply-To: <7vhc4z1gys.fsf@gitster.siamese.dyndns.org>
Message-ID: <m3myerce39.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 20 Dec 2008 02:54:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Current gitweb has a possible local privilege escalation bug that allows a
> malicious repository owner to run a command of his choice by specifying
> diff.external configuration variable in his repository and running a
> crafted gitweb query.
> 
> Recent (post 1.4.3) gitweb itself never generates a link that would result
> in such a query, and the safest and cleanest fix to this issue is to
> simply drop the support for it.  Maintenance release v1.6.0.6, v1.5.6.6,
> v1.5.5.6 and v1.5.4.7 are already available at k.org (see the announcement
> for v1.6.0.6 I sent out a few minutes ago), and the master branch and
> others pushed out tonight have the same fix.

>From what I have found diff.external works only since v1.5.4 (see
commit cbe02100), so when gitweb started using git-diff for old
legacy links to not use $tmpdir and /usr/bin/diff -u it wasn't an
issue...

-- 
Jakub Narebski
Poland
ShadeHawk on #git
