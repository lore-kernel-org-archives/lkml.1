Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYFVUqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYFVUqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYFVUp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:45:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:20387 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbYFVUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OyYS9fNgRGMOJIGvqQQfoDWJVdjZf7Bcq19nIsYJUZDuRYODUUMCdm6CqJiAp1/tdj
         ZueCmRJtK/iaYHUSYSulnxWdWrEGOw7bWKb4al4lEaIwSHeY+RgZJ9cOTr01XIQ6765F
         41b4rEOXg9bni7jnK4hFVMxJ4CyH/Kv8L8sCw=
Message-ID: <84144f020806221345h6a429a0csfef6e3d8d80bdd6d@mail.gmail.com>
Date: Sun, 22 Jun 2008 23:45:57 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Cc: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       tzanussi@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0806221343o3a9e3951j1448e968f9ba9684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621171051.5ed3b522@linux360.ro>
	 <84144f020806221222s7498593ap7cad427405fb6776@mail.gmail.com>
	 <20080622233848.50f14605@linux360.ro>
	 <19f34abd0806221343o3a9e3951j1448e968f9ba9684@mail.gmail.com>
X-Google-Sender-Auth: 92bd4129b68cd747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 11:43 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> By the way -- may I ask why it is called early_initcall() and not
> pre_smp_initcall()? I think it makes sense to encode the exact purpose
> of the initcall into the name. "early" is not very explicit. This is
> just my opinion :-) Thanks.

Sounds good to me.
