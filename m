Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZIITS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZIITS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZIITS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:18:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZIITS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:18:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fJrQeMJJ9Pd1jMKuXX224Vj4b4wiDxnlPIxcIzJRts7Z9EdZtvHAKy490xmR7s0wn
	mQqKInzzildpAPKIQKOhw==
Date: Wed, 9 Sep 2009 12:18:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <1252510129.14385.37045.camel@nimitz>
Message-ID: <alpine.DEB.1.00.0909091217570.32267@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com> <1252510129.14385.37045.camel@nimitz>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Dave Hansen wrote:

> I don't know of any offhand.  Someone mentioned oprofile buffers at some
> point, but I looked through it and it didn't pop out at me.
> 

Their length and element size fit the prerequisites of using flex array, 
but they cannot be copied to userspace as a string the way we can with 
vmalloc'd memory.
