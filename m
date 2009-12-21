Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZLUKYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZLUKYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZLUKYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:24:53 -0500
Received: from ozlabs.org ([203.10.76.45]:59370 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbZLUKYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:24:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] modules: Skip empty sections when exporting section notes
Date: Mon, 21 Dec 2009 20:54:48 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Helge Deller <deller@gmx.de>, Martin Michlmayr <tbm@cyrius.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <1261233781.2418.87.camel@localhost>
In-Reply-To: <1261233781.2418.87.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212054.48469.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009 01:13:01 am Ben Hutchings wrote:
> Commit 35dead4 "modules: don't export section names of empty sections
> via sysfs" changed the set of sections that have attributes, but did
> not change the iteration over these attributes in add_notes_attrs().
> This can lead to add_notes_attrs() creating attributes with the wrong
> names or with null name pointers.
> 
> Introduce a sect_empty() function and use it in both add_sect_attrs()
> and add_notes_attrs().

Looks good, queued.

Thanks!
Rusty.
