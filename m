Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYKZOyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYKZOyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKZOxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:53:51 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:34749 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYKZOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:53:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DnUdgZ1qpwhjG9ZYCaEfMeWkui1pZ1SDDa11KFL8fQK8YOtPlM+/jVzb9XgEPcwM2G
         SFBkabeyj53d9K30CPCg4neUP67nW56Cmk5iAmDNCwcYprr7bibSwXb7Ke+X//HfcyRZ
         TpcI7cU/qSNMd5tS10IsKFjthNhJ5R36qgvR4=
Message-ID: <84144f020811260653w2f65e01boab854492bdbe5ef3@mail.gmail.com>
Date: Wed, 26 Nov 2008 16:53:49 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [patch] slub: make early_kmem_cache_node_alloc void
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0811251853250.5358@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.2.00.0811251853250.5358@chino.kir.corp.google.com>
X-Google-Sender-Auth: c5a8a1dd954498a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 5:14 AM, David Rientjes <rientjes@google.com> wrote:
> The return value for early_kmem_cache_node_alloc() is unused, so it is
> better defined as void.
>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!
