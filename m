Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZGVPDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZGVPDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZGVPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:03:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35500 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZGVPDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:03:04 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
In-Reply-To: <20090722070903.GG6281@cr0.nay.redhat.com>
References: <20090721220017.60A219D3@kernel>
	 <20090722070903.GG6281@cr0.nay.redhat.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 08:02:35 -0700
Message-Id: <1248274955.24021.5.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 15:09 +0800, Amerigo Wang wrote:
> On Tue, Jul 21, 2009 at 03:00:17PM -0700, Dave Hansen wrote:
> >+static inline int __nr_part_ptrs(void)
> 
> How about __nr_ptrs_in_part()?

That would be fine except it is the number of part pointers in the base.
I guess you're proving that I named it horribly. :)

> >+static int fa_index_inside_part(struct flex_array *fa, int element_nr)
> >+{
> >+	return (element_nr % __elements_per_part(fa->element_size));
> >+}
> >+
> >+static int offset_inside_part(struct flex_array *fa, int element_nr)
> 
> How about index_in_part()?

Yeah, I guess that's decent.  I'll go see how it feels when it gets
used.

-- Dave

