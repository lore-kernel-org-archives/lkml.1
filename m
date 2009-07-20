Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZGTVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZGTVMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZGTVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:12:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876AbZGTVMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:12:14 -0400
Date: Mon, 20 Jul 2009 14:11:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com, amwang@redhat.com,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       mszeredi@suse.cz
Subject: Re: [Patch] pipe: use file_update_time() when hold i_mutex
Message-Id: <20090720141150.e9d081ca.akpm@linux-foundation.org>
In-Reply-To: <20090706053745.6338.50777.sendpatchset@localhost.localdomain>
References: <20090706053745.6338.50777.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 01:35:30 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> 
> file_update_time() should be called with i_mutex held,
> move it before mutex_unlock().
> 

Why do you believe that file_update_time() needs i_mutex?
