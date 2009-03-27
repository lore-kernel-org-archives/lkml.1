Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZC0QdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZC0QdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZC0QdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:33:08 -0400
Received: from gw.goop.org ([64.81.55.164]:36479 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbZC0QdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:33:07 -0400
Message-ID: <49CCFFC0.1020904@goop.org>
Date: Fri, 27 Mar 2009 09:33:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lguest@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/5] lguest: avoid accidental recycling of pgdir pages
References: <200903271022.28863.rusty@rustcorp.com.au> <49CC1B1C.3080102@goop.org> <200903271154.22450.rusty@rustcorp.com.au>
In-Reply-To: <200903271154.22450.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Now, I haven't *seen* this happen...
>   

Oh, maybe its because you already zap the shadows on tlb flush, and the 
kernel is careful to tlb flush every pagetable page before freeing...

    J
