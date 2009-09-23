Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZIWKv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZIWKv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZIWKv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:51:57 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52263 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZIWKv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:51:57 -0400
Date: Wed, 23 Sep 2009 12:51:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
Message-ID: <20090923105157.GA31281@merkur.ravnborg.org>
References: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 05:38:01AM -0400, Amerigo Wang wrote:
> 
> I got lots of "ISO C90 forbids mixed declarations and code" warnings
> during compile today's kernel.
> 
> I think we can remove the gcc option '-Wdeclaration-after-statement'
> now, since we already have C99 for 10 years. :)

This is a matter of style more than what C99 allows.
Kernel style is to fobid this(*) so we keep the warning.

(*) Based on reading several threads where this has
been mentioned - I have no specific references to CodingStyle.

	Sam
