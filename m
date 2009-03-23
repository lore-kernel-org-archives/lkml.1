Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZCWE2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZCWE2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZCWE1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:27:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:31452 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZCWE1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kQa8o7uLfxl4G5zMpUo177AgpdN4kdNrZln7/1SKrdvhcLp1w8gvSEo0m7Q4TlLdk9
         qFs7J2sByzh8FmCNc8TqSlCefsyRG5S+ko3JbS8gy+QIzmseQEv4RHS31xYg8iovzZNl
         LaGl0mwVJ//4yTJVV9xhukkzdHkH9XkL+E4TA=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903230151140.11883@blonde.anvils>
References: <Pine.LNX.4.64.0903230151140.11883@blonde.anvils>
Date: Mon, 23 Mar 2009 06:27:48 +0200
X-Google-Sender-Auth: c73f98b5b1648ff4
Message-ID: <84144f020903222127r5982a325o66638bc2bd55d109@mail.gmail.com>
Subject: Re: [PATCH] shmem: writepage directly to swap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>, Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Rohland <hans-christoph.rohland@sap.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 3:57 AM, Hugh Dickins <hugh@veritas.com> wrote:
> Synopsis: if shmem_writepage calls swap_writepage directly, most shmem swap
> loads benefit, and a catastrophic interaction between SLUB and some flash
> storage is avoided.

Nice!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
