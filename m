Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbZIDQUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbZIDQUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbZIDQUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:00 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:52863 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbZIDQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:19:59 -0400
Date: Fri, 4 Sep 2009 18:20:04 +0200
From: Bastian Blank <waldi@debian.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       544145@bugs.debian.org, Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
Message-ID: <20090904162003.GA6147@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com, 544145@bugs.debian.org,
	Keir Fraser <keir.fraser@eu.citrix.com>
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org> <4AA03DE8.40706@goop.org> <20090903223603.GA19945@wavehammer.waldi.eu.org> <4AA13B4B.7020101@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AA13B4B.7020101@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 09:07:39AM -0700, Jeremy Fitzhardinge wrote:
> But for some reason that's triggering a failsafe callback, which invokes
> a GP.

Hmm, not in my tests. It always returned to userspace correctly and died
some operations later, usually the "ret". This then produced either a
segfault (unreadable address), sigill (if it managed to reach the ELF
header of the ld.so) or a GPF.

Bastian

-- 
You!  What PLANET is this!
		-- McCoy, "The City on the Edge of Forever", stardate 3134.0
