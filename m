Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXCXNPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXCXNPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXCXNPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:15:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:5250 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXCXNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:15:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lK+R57E4xyQXddQiOqFNaSZcNYT/bqQFfVg0g2Cql4nE05NQQm/l/42xa+Jx0omczmJxS6bvcyxjxvqD29OCVeOIPVXW7Gcg1tUmIiX21elJAKNXAGLagdQZOTixXl1IH4EzMhn08ZAyn6JL74oclS2Vla/q9dbuTRrhhmWtabU=
Message-ID: <84144f020703240615p98766f9o2f1533f62c061ce4@mail.gmail.com>
Date: Sat, 24 Mar 2007 15:15:30 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [-mm patch] fs/revoke.c: cleanups (and bugfix for 64bit systems)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070324130708.GK752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <20070324130708.GK752@stusta.de>
X-Google-Sender-Auth: 87d91222a9833533
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/24/07, Adrian Bunk <bunk@stusta.de> wrote:
> This patch contains the following:
> - every file should #include the headers containing the prototypes for
>   it's global functions
> - fix the wrong return value of sys_frevoke() gcc was now able to detect
> - make 2 needlessly global structs static
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Looks good. Thanks!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
