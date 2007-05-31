Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXEaAKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXEaAKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXEaAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:09:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59442 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbXEaAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:09:57 -0400
Date: Wed, 30 May 2007 17:09:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: "Luck, Tony" <tony.luck@intel.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <465E0F03.6000103@oracle.com>
Message-ID: <Pine.LNX.4.64.0705301657530.3832@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
 <Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
 <20070530163413.87ecfe18.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705301652100.3731@schroedinger.engr.sgi.com>
 <465E0F03.6000103@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Randy Dunlap wrote:

> OK.  I would write the file to disk and view it with an editor.
> Then at each occurrence of /exit.text/, see if it's inside an __init
> function...

Ahh okay. cscope will do that too.... But all have __exit.

