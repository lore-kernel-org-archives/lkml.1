Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbYEHVLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbYEHVLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbYEHVKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:10:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:65003 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYEHVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hzgH+QPV1fZQaZ5mgn27ydyWdFvZWVDMGRgOllaOcGwuFdvF4+ZMzOoAqV9QFE0S06GhiALQB6MOLWaA5ZyasLhmoxbkqCnXD/GDDqTs3Dzs/2lPYv+ALDxwcl3Ax/ug0SNpQ+SatqnwaD6rcO1ZcEsgdalzR1D78dpQ6IMxtFI=
Message-ID: <84144f020805081410n503b08dap17c9fa4420788e34@mail.gmail.com>
Date: Fri, 9 May 2008 00:10:50 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Subject: Re: [PATCH 1/3] kmemcheck: prepare for SLAB hooks
Cc: clameter@sgi.com, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805090000540.28488@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805090000540.28488@sbz-30.cs.Helsinki.FI>
X-Google-Sender-Auth: 69ee73f3928268db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 12:02 AM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> Make mm/slub_kmemcheck.c more generic in preparation for adding kmemcheck hooks
> to SLAB which does not use compound pages by default and has slightly different
> way for keeping track of object size than SLUB.

And oh, the file ought to be renamed now; it's not SLUB specific at all anymore.
