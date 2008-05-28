Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYE1UfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYE1UfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYE1UfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:35:08 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:9252 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYE1UfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z+8iPBLSkeN6C6Bq5H6SsW0o7JDryRcg2nNZeCpD4LnMsmq1Am/do2wxnjaE7AwobEeS1yKjH2zieRiZR2FBN+RbJxlr9Y2L6s2BPErW5taY/x1nwIpBWHxl97j9N8KhWEDi0N09L5zH48eZZMxATtsGs2ZWy4Wb+vNU/0Pfa2k=
Message-ID: <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
Date: Wed, 28 May 2008 16:35:02 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <7613.1211996335@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2874.1211980355@redhat.com>
	 <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
	 <24762.1211983758@redhat.com>
	 <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
	 <7613.1211996335@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 1:38 PM, David Howells <dhowells@redhat.com> wrote:
> Christoph Lameter <clameter@sgi.com> wrote:
>> Right. SLAB/SLUB align to long long. SLOB needs to do the same.
>
> I fixed it by setting ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN.

what was the change exactly ?  we were seeing alignment problems on
Blackfin and we fixed it with:
http://blackfin.uclinux.org/git/?p=readonly-mirrors/linux-kernel.git;a=commitdiff;h=506175f9d4c8ea43ce5687edb98feb3475c45ea7
-mike
