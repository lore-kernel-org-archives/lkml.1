Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYIRDNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYIRDNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 23:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYIRDNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 23:13:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbYIRDNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 23:13:43 -0400
Date: Wed, 17 Sep 2008 20:13:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: Martin Knoblauch <knobi@knobisoft.de>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
Message-Id: <20080917201334.f680ea1a.akpm@linux-foundation.org>
In-Reply-To: <48D1B21E.3060509@melbourne.sgi.com>
References: <997439.5560.qm@web32601.mail.mud.yahoo.com>
	<48D1B21E.3060509@melbourne.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 11:42:54 +1000 Greg Banks <gnb@melbourne.sgi.com> wrote:

> I think having a tunable for client readahead is an excellent idea,
> although not to solve your particular problem.  The SLES10 kernel has a
> patch which does precisely that, perhaps Neil could post it.
> 
> I don't think there's a lot of point having both a module parameter and
> a sysctl.

mount -o remount,readahead=42
