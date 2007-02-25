Return-Path: <linux-kernel-owner+w=401wt.eu-S965136AbXBYVhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136AbXBYVhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965143AbXBYVhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:37:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965136AbXBYVhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:37:47 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Print error code in page faults
Date: Sun, 25 Feb 2007 22:34:55 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070224053125.GA20487@redhat.com>
In-Reply-To: <20070224053125.GA20487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702252234.56442.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 February 2007 06:31, Glauber de Oliveira Costa wrote:
> When a page faults comes from a kernel space, the printed summary
> leaves us clueless about what kind of access was being tried (which
> is encoded in the error_code variable).
> 
> Having it promply available may ease debugging in a bunch of
> situations.

It's in the __die output. I don't think outputting it twice is needed

-Andi

