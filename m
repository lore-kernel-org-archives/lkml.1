Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbXGIP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbXGIP7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXGIP7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:59:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbXGIP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:59:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=S44POKubqNYSif4bY5rXgi76Jb+eG7Ew4Ti12lIkr1NUh+Kvlen/BgM20L4buOHbV
	tCoiwqeBjGoqXzdLlk1Pw==
Message-ID: <46925B5D.8000507@google.com>
Date: Mon, 09 Jul 2007 08:59:25 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality, performance
 and maintenance
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de> <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sun, 8 Jul 2007, Andi Kleen wrote:
> 
>> Christoph Lameter <clameter@sgi.com> writes:
>>
>>> A cmpxchg is less costly than interrupt enabe/disable
>> That sounds wrong.
> 
> Martin Bligh was able to significantly increase his LTTng performance 
> by using cmpxchg. See his article in the 2007 proceedings of the OLS 
> Volume 1, page 39.
> 
> His numbers were:
> 
> interrupts enable disable : 210.6ns
> local cmpxchg             : 9.0ns

Those numbers came from Mathieu Desnoyers (LTTng) if you
want more details.

