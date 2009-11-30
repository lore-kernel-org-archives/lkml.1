Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZK3RNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZK3RNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZK3RNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:13:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:53682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbZK3RNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:13:42 -0500
Message-ID: <4B13FD4B.5080805@suse.cz>
Date: Mon, 30 Nov 2009 18:13:47 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: specify absolute paths for cscope
References: <1259238852-21214-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1259238852-21214-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.11.2009 13:34, Daniel Vetter wrote:
> Some tools (like my favourite editor, vim) can't handle relative
> paths from cscope as soon as cscope.out is no longer in $PWD. Use
> absolute paths when generating cscope.files, which seems to be
> the recommended way to generate cscope.out, anyway (at least according
> to cscope.sf.net).

But it will fail if you rename the source directory. I'm not sure what
is worse, I myself don't use cscope much. Fixing vim would be the ideal
solution of course (it already handles ../tags fine).

Michal
