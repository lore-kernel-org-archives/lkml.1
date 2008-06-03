Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYFCWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYFCWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYFCWcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:32:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYFCWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:32:20 -0400
Date: Tue, 3 Jun 2008 15:30:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
 buffers
Message-Id: <20080603153050.fb99ac8a.akpm@linux-foundation.org>
In-Reply-To: <4843CEED.9080002@hitachi.com>
References: <4843CE15.6080506@hitachi.com>
	<4843CEED.9080002@hitachi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 19:43:57 +0900
Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> 
> In ordered mode, we should abort journaling when an I/O error has
> occurred on a file data buffer in the committing transaction.

Why should we do that?
