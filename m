Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbYCFCC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbYCFCC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYCFCCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:02:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbYCFCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:02:47 -0500
Date: Wed, 5 Mar 2008 18:02:41 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 9/9] Devices accessibility control group itself
Message-ID: <20080306020241.GB5359@kroah.com>
References: <47CED717.60406@openvz.org> <47CEDCAE.5050303@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CEDCAE.5050303@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 08:47:26PM +0300, Pavel Emelyanov wrote:
> Finally, here's the control group, which makes full use of the
> interfaces, declared in the previous patches.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
>  Documentation/controllers/devices.txt |   61 +++++++

The information here should be in Documentation/ABI/ right?

I still don't see how changing these permissions within the kernel is
going to affect anything outside of it, nor why you want to be tracking
this within the kernel itself.

What's wrong with just having different /dev trees for the different
containers?  That would not require any kernel changes, and you don't
have to write a tool to be sending these odd "mode settings" into the
kernel.

thanks,

greg k-h
