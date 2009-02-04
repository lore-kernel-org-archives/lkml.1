Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZBDLfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZBDLfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbZBDLfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:35:21 -0500
Received: from ozlabs.org ([203.10.76.45]:43948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZBDLfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:35:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 6/7] Ksplice: Export symbols needed for Ksplice
Date: Wed, 4 Feb 2009 22:05:08 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-6-git-send-email-jbarnold@mit.edu> <1228521840-3886-7-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-7-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042205.09651.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:33:59 Jeff Arnold wrote:
> From: Tim Abbott <tabbott@mit.edu>
> 
> Ksplice uses several functions from module.c in order to resolve
> symbols and implement dependency handling.  Calling these functions
> requires holding module_mutex, so it is exported.

I have fought every attempt to export that.  It was long a cause of misery
and pain; people saw the lock and so started grabbing it.

Any chance we can find another way?
Rusty.
