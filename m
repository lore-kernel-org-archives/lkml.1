Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049Ab0BZU3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:29:37 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35870 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966030Ab0BZU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:29:36 -0500
Date: Fri, 26 Feb 2010 15:29:17 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 2/2] umh && creds: kill subprocess_info->cred logic
Message-ID: <20100226202917.GD31078@hmsreliant.think-freely.org>
References: <20100226182325.GA31674@redhat.com>
 <20100225181500.GA18008@redhat.com>
 <16951.1267207238@redhat.com>
 <17603.1267209668@redhat.com>
 <20100226200313.GA16092@redhat.com>
 <20100226200435.GC16092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226200435.GC16092@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 09:04:35PM +0100, Oleg Nesterov wrote:
> Now that nobody ever changes subprocess_info->cred we can kill this
> member and related code. ____call_usermodehelper() always runs in the
> context of freshly forked kernel thread, it has the proper ->cred
> copied from its parent kthread, keventd.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

