Return-Path: <linux-kernel-owner+w=401wt.eu-S935162AbXLQW7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162AbXLQW7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbXLQW64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:58:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:9493 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbXLQW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:58:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GBkp99XT8e9SxN8rIXylgS88tLEnnC6nWPQCpO+VBJ12umvtO+QdmUVdE1ksTkCJq1d4qUCRcEJ4lb4O/pUnKZuVpBXq/+cKtho0Cg+ye0DJaT0RKykCaPIyMk/Qd0dSveAfkDUKOKFy9JJE027davD/ArN05UKDxRM/7LJH/2o=
Message-ID: <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:58:52 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Top kernel oopses/warnings this week
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, protasnb@gmail.com,
       tytso@thunk.org
In-Reply-To: <20071217133631.5bbc5842@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu>
	 <20071217133631.5bbc5842@laptopd505.fenrus.org>
X-Google-Sender-Auth: 25a3c8ef8eb3a0be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       static char target[80];
 ...
> +               sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
> +                       "%02x%02x%02x%02x%02x%02x",

[80] is overkill ... [37] bytes should be enough (unless I went
cross-eyed counting the "%02x" :-)

-Tony
