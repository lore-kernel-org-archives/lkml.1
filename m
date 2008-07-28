Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYG1IMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYG1IMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYG1IMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:12:44 -0400
Received: from gw.goop.org ([64.81.55.164]:55118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYG1IMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:12:43 -0400
Message-ID: <488D7F79.40102@goop.org>
Date: Mon, 28 Jul 2008 01:12:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: How to get a sense of VM pressure
References: <488A1398.7020004@goop.org> <1217230570.6331.6.camel@twins>
In-Reply-To: <1217230570.6331.6.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Have a peek at this:
>
>   http://people.redhat.com/~riel/riel-OLS2006.pdf
>
> The refault patches have been posted several times, but nobody really
> tried to use them for your problem.
>   

Yep, Rik pointed the paper and patches out to me.  Seems like an 
interesting approach to play with.  The refaulting measure is nice 
because it should give a fairly good idea of how much memory you need to 
add to get the fault rate down below some particular level.  It doesn't 
help with shrinking, other than telling you you've gone too far, and how 
much too far, which is definitely useful to know.

    J
