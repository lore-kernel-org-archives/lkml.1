Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYBSXXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYBSXXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYBSXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:23:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYBSXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:23:13 -0500
Date: Tue, 19 Feb 2008 15:21:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-Id: <20080219152129.6e8b7956.akpm@linux-foundation.org>
In-Reply-To: <20080219165502.2c202759@crazy>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
	<20080218041340.f1e46ec9.akpm@linux-foundation.org>
	<20080219165502.2c202759@crazy>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 16:55:02 +0100 Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Le Mon, 18 Feb 2008 04:13:40 -0800,
> Andrew Morton <akpm@linux-foundation.org> a __crit :
> 
> > Option 3 wold be to add more #ifdef CONFIG_DMI lines around the
> > place.  How ugly would that get?
> 
> Like the attached patch. #ifdef CONFIG_DMI everywhere :-(
> 

ug, sorry, if I'd realised it was like this I'd have said "don't bother". 
Apart from the obvious problem, this means that people will keep breaking
CONFIG_DMI=n all the time, because they will forget the ifdefs, and the
number of people who test with CONFIG_DMI=n will be small.


