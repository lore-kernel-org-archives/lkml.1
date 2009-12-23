Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZLWOsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZLWOsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbZLWOso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:48:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61587 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbZLWOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <1261532718.575722.541804401419.2.gpush@pororo>
References: <1261532718.575048.365032094903.0.gpush@pororo> 
	<1261532718.575722.541804401419.2.gpush@pororo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 23 Dec 2009 07:48:23 -0700
X-Google-Sender-Auth: 9af756df6fd8ce21
Message-ID: <fa686aa40912230648r3294e8f8m855ae91e490a9edd@mail.gmail.com>
Subject: Re: [PATCH 2/3] of: make set_node_proc_entry private to 
	proc_devtree.c
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 6:45 PM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> We only need set_node_proc_entry in proc_devtree.c, so move it there.
>
> This fixes the !HAVE_ARCH_DEVTREE_FIXUPS build, as we can't make make
> the definition in linux/of.h conditional on this #define (definitions in
> asm/prom.h can't be exposed to linux/of.h, due to the enforced #include
> ordering).
>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

A little ugly, but it can probably be refactored and cleaned up later
(like a lot of other things in the merged code).  Otherwise these
three patches look good to me.  I've picked them up into my tree and
I'll push them out soon.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
