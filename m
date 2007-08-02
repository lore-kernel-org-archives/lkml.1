Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbXHBReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbXHBReX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXHBReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:34:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:6266 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXHBReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fpwPvOrUWE59oJWRPhLvUAddlqQxiYzuiVaaFRB9Iq1NCSb1wk6Cw5qlmgbYkw6XJET9NaettT1suICwSMvMghPG1EPoeC9t5FxuIq0Dglei5snIX0zUp1gbxAP3hiBkPA0Q3Vi7PIpttT79sZgKrtCeEUXLAufz2hlc8PR6WFs=
Message-ID: <46B2158F.4060302@gmail.com>
Date: Fri, 03 Aug 2007 02:34:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.23-rc1-mm2: Fix crash in sysfs_hash_and_remove
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708021931.58123.rjw@sisk.pl>
In-Reply-To: <200708021931.58123.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> My test box crashes during suspend, while the nonboot CPUs are being disabled,
> because sysfs_hash_and_remove() doesn't check if dir_sd passed to it is not
> NULL.  Fix it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

It got broken when shadow support was added.  The shadow support in -mm1
will be dropped and Eric is preparing a new version.  So, this fix
probably won't be necessary from -mm2.

Thanks.

-- 
tejun
