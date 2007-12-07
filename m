Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXLGSgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXLGSgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXLGSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:36:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:34013 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbXLGSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hPCsC3DvX79IEc/uGM84U3uCesIACHXyUZ3l1m6ptbvoDnISMQoW8jiry/sEysppGcDrK/GbJjyn8Or3guRU2pQcWmaiMks9lJ9c1nuHxQ0yAXH05w+LWF2Yc2t33os84xXyySLrZd6NZ0AtKISP1ph2Cr3yMcuV+M7NFZFFU7Y=
Message-ID: <fa4052ef0712071036q2f2f22e7tfdeb7bf73ba4278b@mail.gmail.com>
Date: Fri, 7 Dec 2007 13:36:13 -0500
From: Shane <gnome42@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Cc: linux-kernel@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <20071207040219.e231cbc7.akpm@linux-foundation.org>
	 <fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I will do a few more builds/boots and check -rc3-git2 and -rc3-git3.

Okie, the problem was introduced in 2.6.24-rc3-git2.

2.6.24-rc3-git1   Good
2.6.24-rc3-git2   Bad

The exact output from one 'ls' command is:

ls: /dirA/dirB/dirC: Stale NFS file handle
ls: /dirA/dirB/dirC: Stale NFS file handle

Shane
