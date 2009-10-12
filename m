Return-Path: <linux-kernel-owner+w=401wt.eu-S933515AbZJLWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515AbZJLWas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbZJLWar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:30:47 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:40037 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483AbZJLWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V/nMc5uu6fhn0MSOUGxmK/xSnqMZTTgvgLcoLkVKyYXCyx5xcH+Fo8/iXfNJSS6EGX
         WTdjkPnCw7VcOkU6HqaKy95+CzziVfYYdblfqTHbG5AR+VPTF1/+2/J/hcJmfUr5Z0+m
         qcZ3Ds/qa17x/5JuMz0FbpUrHarbuTwrGw06Q=
Date: Tue, 13 Oct 2009 00:30:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: [PATCH] kill-the-bkl/reiserfs: fix reiserfs lock to
	cpu_add_remove_lock dependency
Message-ID: <20091012223005.GA4711@nowhere>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com> <1255386309-4992-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255386309-4992-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:25:02AM +0200, Frederic Weisbecker wrote:
> This can be fixed by relaxing the reiserfs lock while creating the
> workqueue.
> This is fine to relax the lock here, we just keep it around to pass
> through reiserfs lock checks and for paranoid reasons.


Nothing related to kprobes that said...
Sorry for the noise. I've already posted this patch, but it
looks like these locking inversions don't want to live
their own life and follow me everywhere...

