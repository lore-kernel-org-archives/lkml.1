Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYBRQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYBRQT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYBRQTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:19:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14584 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbYBRQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:19:19 -0500
Date: Mon, 18 Feb 2008 08:13:15 -0800
From: Daniel Walker <dwalker@mvista.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mike.miller@hp.com, alexn@dsv.su.se
Subject: Re: 2.6.25-rc2-mm1: new create_proc_entry() users
Message-ID: <20080218161315.GQ4391@dwalker1.mvista.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080217105050.GC6596@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217105050.GC6596@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:50:50PM +0300, Alexey Dobriyan wrote:
> > profile-likely-unlikely-macros
> > page-owner-tracking-leak-detector
> > cciss-procfs-updates-to-display-info-about-many-volumes
> 
> Guys, create_proc_entry() is slightly racy in case of modular code and
> proc_create() was invented to fix it. Eventually all create_proc_entry()
> users will be converted to proc_create(), so please do it for new code.

profile-likely-unlikely-macros isn't new code, but I can still conver it
to proc_create() if you like..

Daniel
