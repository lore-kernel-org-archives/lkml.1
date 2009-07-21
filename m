Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZGUWJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZGUWJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZGUWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:09:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32893 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbZGUWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:09:07 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
In-Reply-To: <20090721220017.60A219D3@kernel>
References: <20090721220017.60A219D3@kernel>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:09:05 -0700
Message-Id: <1248214145.13249.5671.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 15:00 -0700, Dave Hansen wrote:
> 
> The interface is dirt simple.  4 functions:
>         alloc_flex_array()
>         free_flex_array()
>         flex_array_put()
>         flex_array_get()
> 
> put() appends an item into the array while get() takes
> indexes and does array-style access.

I need to update this description, but the kerneldoc comments are up to
date.

That reminds me...  People will get somewhat weird behavior if they mix
flex_array_append() and flex_array_put().  Is that OK?  Should
flex_array_put() modify ->nr_elements to point to the element past the
one that was just put()?  Should we perhaps drop the append() function
and the ->nr_elements variable completely?

-- Dave

