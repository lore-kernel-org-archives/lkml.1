Return-Path: <linux-kernel-owner+w=401wt.eu-S1750859AbYBHVa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859AbYBHVa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYBHVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:30:12 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44968 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYBHVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:30:10 -0500
Subject: Re: [-mm PATCH] sysdev_unregister() should call kobject_del()
From: Dave Hansen <haveblue@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1202488925.26309.60.camel@dyn9047017100.beaverton.ibm.com>
References: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com>
	 <20080208003825.GB27317@kroah.com>
	 <1202433946.26309.47.camel@dyn9047017100.beaverton.ibm.com>
	 <20080208045533.GA10988@kroah.com>
	 <1202447322.13910.3.camel@badari-laptop.beaverton.ibm.com>
	 <20080208054158.GA12742@kroah.com>
	 <1202488925.26309.60.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 13:30:05 -0800
Message-Id: <1202506205.20159.17.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 08:42 -0800, Badari Pulavarty wrote:
> 
> I can add remove link before unregister() as you suggested.
> 
> Regarding accessing kobject after freeing up, no one calls with
> "root".
> Why not clean it up first, like this ? 
> 
> Dave, are you okay with this ?

Yeah, I don't see any users of it, either.  It looks fine to me.

-- Dave

