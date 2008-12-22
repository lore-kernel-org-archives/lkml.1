Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYLVUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYLVUWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYLVUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:22:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55628 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYLVUWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:22:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.28-rc9 regression: system fails to suspend
Date: Mon, 22 Dec 2008 21:22:51 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200812220904.28780.arvidjaar@mail.ru>
In-Reply-To: <200812220904.28780.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812222122.52019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 of December 2008, Andrey Borzenkov wrote:
> I will bisect as time permits, but may be it rings the bell for someone. 
> 2.6.28-rc7 is OK; rc9 switches console off and never goes in suspend. 
> Power remains on, keyboard is non-functional and the only way out is 
> power button. I have not tried rc8.
> 
> If somebody has soggestions what to (try to) revert, it would be great 
> and save quite a bit of time for bisecting.

You can have a look at the list of regressions at
http://bugzilla.kernel.org/showdependencytree.cgi?id=11808
find the fixes applied between .28-rc7 and .28-rc9 and check those commits.

Thanks,
Rafael
