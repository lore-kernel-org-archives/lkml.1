Return-Path: <linux-kernel-owner+w=401wt.eu-S1751522AbYKFWOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbYKFWOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYKFWNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:13:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664AbYKFWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:13:50 -0500
Date: Thu, 6 Nov 2008 14:13:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: Re: [PATCH 5/5] eCryptfs: Filename Encryption: mount option
Message-Id: <20081106141304.b675cb9e.akpm@linux-foundation.org>
In-Reply-To: <20081104214313.GE6677@halcrowt61p.austin.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
	<20081104214313.GE6677@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 15:43:13 -0600
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Enable mount-wide filename encryption by providing the Filename
> Encryption Key (FNEK) signature as a mount option. Note that the
> ecryptfs-utils userspace package versions 61 or later support
> this option.

A usage example would, as always, be useful here.

Do we actually provide a secure key on the command line?  If so, do any
special steps need to be taken to prevent unauthorised viewing of it? 
Fancy things like `cat /proc/mounts' :)


