Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYBWLvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYBWLvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYBWLvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:51:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:46276 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYBWLvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HFoneDe6J6fmP3JUhRioi131Qhb8QkRQoQUQbKEt/bsvbzJtTsi827g6OXt1rLqg6SwDs6fy1LXQ23tidGxg4h9FfrH9/rf7yi7bxBLW8/8wthLByq8N+CWHALoMlwiGScF2ralP6eG+ZM5/MLUHrrQSTm8PX9BZIj+zHevE7es=
Message-ID: <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
Date: Sat, 23 Feb 2008 13:51:34 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080223001130.d8922136.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <20080223001130.d8922136.akpm@linux-foundation.org>
X-Google-Sender-Auth: 45b05e6646dc9ba1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not if
>  your distributor already did it for you.

Have you tried sysprof? It's really nice to setup and use compared to
oprofile when profiling user-space.

On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  This code adds a new kernel->userspace interface which is not even
>  documented in code comments.  It appears to use a pollable debugfs file in
>  /proc somewhere, carrying an unspecified payload.

Hmm, it does include <linux/proc_fs.h> but seems to set up a regular
debugfs directory (usually mounted in /sys/debug) and not proc. Arjan?
