Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZDWVHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZDWVHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZDWVGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:06:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38747 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501AbZDWVGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:06:44 -0400
Date: Thu, 23 Apr 2009 17:04:45 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch] serial: add parameter to force skipping the test for
 the TXEN bug
Message-ID: <20090423170445.7ce43951@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090421124745.a641b1eb.akpm@linux-foundation.org>
References: <20090420180549.335552bb@dhcp-100-2-144.bos.redhat.com>
	<20090421124745.a641b1eb.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 12:47:45 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 20 Apr 2009 18:05:49 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > serial: add parameter to force skipping the test for the TXEN bug
> > 
> > Allow users to force skipping the TXEN test at init time. Applies
> > to all serial ports. Intended for debugging only.
> > 
> 
> <scratches head @ changelog>
> 
> 
> Why is this useful?  What is the problem which you're solving here?

There is a blacklist for devices where we need to skip the test but the list is
not complete. This lets users force skipping the test so we can determine if they
need to be added to the list.

Some HP machines with weird serial consoles have this problem and there may be more.

