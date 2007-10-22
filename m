Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbXJVJaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbXJVJaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXJVJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:30:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:1624 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbXJVJaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Nbxi0y+jJOc2SivaBsM8OfrYmXK79ECThZGLy6BHxWsK8VvIrwCnmpeALsF0pkyks7EhUiqtQweY+Ny0Ne1iWL8plTDcSJR09LGCfQflz+AqdJ0jtgrF1TPiNZ+wJDkgIzW+g046xUgjbWmIFsmNbNQQDn5snY867Wz9/97wQD0=
Message-ID: <84144f020710220230t24d95470o7cabec4450e68814@mail.gmail.com>
Date: Mon, 22 Oct 2007 12:30:00 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] return hidden bug
Cc: "Roel Kluin" <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071021214209.1a7567d7@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471BF741.2020501@tiscali.nl>
	 <20071021214209.1a7567d7@bree.surriel.com>
X-Google-Sender-Auth: fedfaafeb5df63a5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/22/07, Rik van Riel <riel@redhat.com> wrote:
> BUG() will terminate the process that runs into it, so you can
> just remove the return alltogether.  If BUG() is hit, the return
> will never be reached.

This isn't true when CONFIG_BUG is disabled (in embedded builds, for example).

                                    Pekka
