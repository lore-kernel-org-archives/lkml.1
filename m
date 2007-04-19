Return-Path: <linux-kernel-owner+w=401wt.eu-S1766882AbXDSRJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766882AbXDSRJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766884AbXDSRJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:09:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33786 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766882AbXDSRJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:09:04 -0400
Date: Thu, 19 Apr 2007 18:12:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Marat Buharov <marat.buharov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: why UDF have so ugly filesize limit?
Message-ID: <20070419181221.59c3c7bd@the-village.bc.nu>
In-Reply-To: <46279F3B.8050807@redhat.com>
References: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>
	<46279F3B.8050807@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 12:56:27 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Marat Buharov wrote:
> > from fs/udf/super.c:
> > in function udf_fill_super
> > sb->s_maxbytes = 1<<30; (1 GB)
> > 
> > Why sb->s_maxbytes is not equal to MAX_LFS_FILESIZE?
> > 
> 
> Patches to fix that are in the -mm kernel already (and in
> Fedora Core 6 latest update.)

Good to know, presumably these also fix the underlying UDF problems in the
UDF filesystem code that caused it to be put there in the first pace ?

(Security CVE-2006-4145)

Alan
