Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbXFUTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbXFUTyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXFUTyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:54:08 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:45526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXFUTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=rCfjwgnJkDQtWUPYiEomciRqLB0CBK8uEJ4usUChYHHjscWxioD6hPxP7WDM6Q+dlmPyWNYQ/P7tbAyJ6AvPmhciy33m5PgyVeNG3z4r2PbOdBphzdSe8WdV4raTLRdl4vJ/8jwUUt9DTrpAxRFF6W3xeApjoKTQDLDHznztyNQ=
Message-ID: <c6d9bea0706211254r6d457e36wfb3722880a3b4abd@mail.gmail.com>
Date: Thu, 21 Jun 2007 15:54:05 -0400
From: "C. Scott Ananian" <cscott@laptop.org>
To: linux-kernel@vger.kernel.org
Subject: inotify and /proc?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 41c39d5d0c92aa34
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to make a read-only /proc file which supports inotify -- that
is, the kernel can send change notifications to userland via the
inotify mechanism.  I've found fsnotify_modify() (in
include/linux/fsnotify.h) which seems to do what I want, but it takes
a struct dentry * -- how can I get a dentry from a struct
proc_dir_entry and increment its ref count to keep it around?  Any
help would be appreciated.  Thanks!
 --scott

-- 
                         ( http://cscott.net/ )
