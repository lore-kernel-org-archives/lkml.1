Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYKUTKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYKUTKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYKUTKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:10:07 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45979 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYKUTKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:10:06 -0500
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1227289690.11607.41.camel@nimitz>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
	 <1227289690.11607.41.camel@nimitz>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 14:09:47 -0500
Message-Id: <1227294587.12636.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 09:48 -0800, Dave Hansen wrote:
> On Thu, 2008-11-20 at 11:43 -0500, Mimi Zohar wrote:
> > 
> > +static inline void tget(struct template_list_entry *entry)
> > +{
> > +       atomic_inc(&entry->refcount);
> > +}
> > +
> > +static inline void tput(struct template_list_entry *entry)
> > +{
> > +       if (atomic_dec_and_test(&entry->refcount))
> > +               kfree(entry);
> > +}
> 
> Seems like a good place for a kref.
> 
> -- Dave

Thanks!

Mimi

