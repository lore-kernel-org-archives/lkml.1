Return-Path: <linux-kernel-owner+w=401wt.eu-S1764152AbXLNKKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764152AbXLNKKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXLNKKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:10:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:39426 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXLNKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lOg5mcDqCeoQizmmdCFoD30MTMPN8WL0ZPGUbvkh1soT3UMlQssJrjxLw42Q8m2Ud0gQGO4PYB/0fzu+Sn/iACmNcv/QJESCoqomZAEB1xOxXfbdpoORWQE0MEW21Um2TilJa/upNu35sBAVWHjrBiOnJEUd8YDRBC2JqMJ++fQ=
Subject: Re: [PATCH 1/4] x86: clean up asm-x86/page*.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <47623AD6.6090403@goop.org>
References: <47623AD6.6090403@goop.org>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 02:10:02 -0800
Message-Id: <1197627002.898.58.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-14 at 00:12 -0800, Jeremy Fitzhardinge wrote:
> Unify common definitions in page*.h.  To simplify other code, I added
> typedefs for the value of pte/pmd/pud/pgd values, so they can be used
> symbolically elsewhere without needing to have lots of 32/64/PAE
> tests.
> 
> Also, add PAGETABLE_LEVELS define so that other definitions can test
> for it directly rather than using indirect 32/64/PAE tests.
> 
> Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

I've been looking at unifying pageattr_32|64.c, if you're headed there
soon I'll look elsewhere, otherwise I'll build on top of this work.

Harvey

