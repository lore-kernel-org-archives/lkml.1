Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYIORdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYIORdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYIORdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:33:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59939 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYIORdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:33:15 -0400
Date: Mon, 15 Sep 2008 10:31:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] kernel-doc: allow structs whose members are all private
Message-Id: <20080915103154.9edf6f69.randy.dunlap@oracle.com>
In-Reply-To: <20080915172648.GA2856@infradead.org>
References: <20080915100229.cf32f74e.randy.dunlap@oracle.com>
	<20080915172648.GA2856@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 13:26:48 -0400 Christoph Hellwig wrote:

> On Mon, Sep 15, 2008 at 10:02:29AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix kernel-doc to handle structs whose members are all private;
> > otherwise invalid XML is generated:
> 
> What's supposed to be a private member? 

Struct members may be marked as private by using
	/* private: */
before them, as noted in Documentation/kernel-doc-nano-HOWTO.txt:

<quote>
Inside a struct description, you can use the "private:" and "public:"
comment tags.  Structure fields that are inside a "private:" area
are not listed in the generated output documentation.

Example:

/**
 * struct my_struct - short description
 * @a: first member
 * @b: second member
 *
 * Longer description
 */
struct my_struct {
    int a;
    int b;
/* private: */
    int c;
};
</quote>


---
~Randy
