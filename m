Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYBSRm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYBSRm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYBSRmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:42:18 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:44845 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYBSRmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:42:17 -0500
Date: Tue, 19 Feb 2008 09:41:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-Id: <20080219094147.b9e0e99b.randy.dunlap@oracle.com>
In-Reply-To: <20080219165502.2c202759@crazy>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
	<20080218041340.f1e46ec9.akpm@linux-foundation.org>
	<20080219165502.2c202759@crazy>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 16:55:02 +0100 Thomas Petazzoni wrote:

> Le Mon, 18 Feb 2008 04:13:40 -0800,
> Andrew Morton <akpm@linux-foundation.org> a écrit :
> 
> > Option 3 wold be to add more #ifdef CONFIG_DMI lines around the
> > place.  How ugly would that get?
> 
> Like the attached patch. #ifdef CONFIG_DMI everywhere :-(


Does this patch apply to -mm?  Seem like No.

After converting it from mime(?) to ASCII and fixing one #if
(change "and" to "&&") & fixing patch rejects, it does build cleanly.


---
~Randy
