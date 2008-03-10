Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYCJVPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYCJVPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbYCJVOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:14:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59864 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbYCJVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:14:50 -0400
Date: Mon, 10 Mar 2008 14:14:36 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>
Subject: Re: root_plug: use cap_task_prctl
Message-ID: <20080310211436.GB6622@kroah.com>
References: <20080310205720.GB13013@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310205720.GB13013@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 03:57:20PM -0500, Serge E. Hallyn wrote:
> With the introduction of per-process securebits, the capabilities-related
> prctl callbacks were moved into cap_task_prctl().  Have root_plug use
> cap_task_prctl() so that PR_SET_KEEPCAPS is defined.
> 
> (Andrew, I didn't put patch numbers here, but there are only two of
> these.  These are the LSMs which internalize capabilities.  The dummy
> module will continue to not support PR_SET_KEEPCAPS).
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

