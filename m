Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXF3DqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXF3DqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbXF3DqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:46:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:56880 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbXF3DqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=C03Ct7SyLtrx0tXEK0Hat1io8aJF6K2vPLsEEUCZNyIsxzCrSRZHbWVm4YbQ3mGoO9ADg6BIrAjofySoYECSfnqaEqhQSzuJKlKdhlnS2rCu3ydbKl3iAf7bVJ7+4opPbGK9LqEfMBNDS7ewWg9tYNowRTnlriOFcg4zRD7TqjY=
Date: Sat, 30 Jun 2007 12:37:00 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to enable dev_dbg messaging
Message-ID: <20070630033700.GA4221@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Jay Cliburn <jacliburn@bellsouth.net>, linux-kernel@vger.kernel.org
References: <20070629222933.24e76cb5@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629222933.24e76cb5@osprey.hogchain.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 10:29:33PM -0500, Jay Cliburn wrote:
> How do I turn on dev_dbg messaging in the kernel?  I can get
> printk(KERN_DEBUG ...) to work just fine, but I don't know how to
> enable dev_dbg.

Defining DEBUG before including <linux/device.h> enables dev_dbg to work.

