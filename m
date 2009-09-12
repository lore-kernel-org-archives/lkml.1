Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZILDYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZILDYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZILDYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:24:03 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:48032 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZILDYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=k/ZBuTEnKGi8bNInIM/ea4Pa95rqkcZlFiZgRraYmE1ofnC9tdticZ40Rwzcbmz740
         YqpjIbS4nE3ZoXvURHQXWF6dk31uuXrh2NkwyKs59Mwl7Jui48oJ8gFOrn5RzALcy9Hi
         fXeTQZcbX9HQukj1jDwcUuOIQ4ILfl9KixYL8=
MIME-Version: 1.0
Date: Sat, 12 Sep 2009 08:54:02 +0530
Message-ID: <1f808b4a0909112024l11815fcbiad9a2d3748a6bafb@mail.gmail.com>
Subject: one question about shared mappings between user space and kernel 
	space.
From: Peter Chacko <peterchacko35@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel geeks,

Please forgive me if this questions was asked already in the past !!!

I  have a question about shared memory mappings between kernel and
user process...(.like accessing device memory directly from user space
through device mmap interface)...I  presume this mechanism use
remap_pfn_range() or similar....when such mappings are in place, (
whats the "U/S" flag in the underlying physical page indicating CPL of
the page) for such pages ? such page  descriptors  are stored in
normal GDT  or considered as global pages ? Any special  policies of
TLB flush of  translations to such pages ?

With a shared memory between user process and kernel using such
mechanism, is it equivalent to  zero-copy transfer between user space
and kernel space? ( I mean any extra overhead in  memory access to
such pages)

I would appreciate your thoughts on this.

-- 
Best regards,
Peter Chacko

NetDiox computing systems,
Network storage & OS  training and research.
Bangalore, India.
www.netdiox.com
080 2664 0708
