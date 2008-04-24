Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYDXM1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYDXM1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbYDXM1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:27:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42882 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbYDXM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mLpKsxd1Y1VTpPVl3S8Jds0B79fy/nDmSWAsX+MArxBo4Dh5NOZ/jRFC/sCfazjRRKN6HEbniQrl5yXjuHXfOv+3swUDxarspl8buhQmM4Q4bD+MbKdNxSLtIWACV4oi2bLpUQHoZyccbqBDhr+ZoZ0Kbgptci5A7pbrkzZ3uu4=
Message-ID: <517f3f820804240527l66e4372dt9d6cdc293e35899d@mail.gmail.com>
Date: Thu, 24 Apr 2008 14:27:28 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
X-Google-Sender-Auth: eb3440611afc3450
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/08, Ulrich Drepper <drepper@redhat.com> wrote:
> The alternative to using sys_indirect is to create a whole bunch of new
>  syscalls.  Here the beginning.  These are the socket interfaces which
>  create file descriptors and therefore need a flags parameter to let
>  the caller decide about setting the close-on-exit bit.

Ulrich,

Could you please CC me on patches that make kernel-userland API changes.

Cheers,

Michael
