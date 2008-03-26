Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbYCZLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbYCZLtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYCZLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:49:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:9846 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYCZLtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zz9ixKrKQfSyu46k7eV9n0bGm9kAw0ocYUVxOdeG8//UzQq36ebuVIJUQbo67jIumzfXuQ5gRdAm5fpOBrLfyZf5Po0h6y3TQ8y2iIdoeHKwwQKDHcCmHJOR+BzeeqH/ScIFXL3StPiPiLcK5XvUbvadcfssA++/MvaYIvYVOgs=
Message-ID: <5d6222a80803260449j7ca69d4dj68e5e80810afb469@mail.gmail.com>
Date: Wed, 26 Mar 2008 08:49:29 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] [PATCH] move apic declarations to mach_apic.h
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, yhlu.kernel@gmail.com
In-Reply-To: <20080326044901.GA3121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080325150630.GA13828@elte.hu>
	 <1206462537-8427-1-git-send-email-gcosta@redhat.com>
	 <1206462537-8427-2-git-send-email-gcosta@redhat.com>
	 <1206462537-8427-3-git-send-email-gcosta@redhat.com>
	 <20080325195818.GA12302@elte.hu> <47E96A29.4000503@redhat.com>
	 <20080326044745.GA2918@elte.hu> <20080326044901.GA3121@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 1:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>  > there's another build error i found:
>  >
>  >  arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
>  >  arch/x86/kernel/setup.c:87: error: expected ',' or ';' before '__attribute__'
>  >
>  > config attached. This is with and without your second patch. (i.e.
>  > independent problem, introduced by the 1/2 patch)
>
>  sorry - this is not your build bug :-)
>

Heh. My reaction when I saw it was "Oh no, I can't believe it!"

-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
