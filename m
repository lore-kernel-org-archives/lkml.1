Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYJaHGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYJaHGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYJaHGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:06:08 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:12807 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530AbYJaHGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:06:07 -0400
Date: Fri, 31 Oct 2008 16:05:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: michael <trimarchi@gandalf.sssup.it>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [RFC PATCH] Correct the interrupt handler in sh4 serial device.
Message-ID: <20081031070527.GC26928@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	michael <trimarchi@gandalf.sssup.it>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Trimarchi <trimarchimichael@yahoo.it>
References: <490756B9.7000902@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490756B9.7000902@gandalf.sssup.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 07:15:21PM +0100, michael wrote:
> Correct the interrupt handler in sh4 serial device,
> return the correct value and check for what is anabled
>  in the SCSCR register. The sh7722 is broken just sending
> a break using minicom. I'm not sure for the value of
> SCI_CTRL_FLAGS_REIE in all architecture.
> 
> Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
> 
Yes, this looks like a good change. It's a good indicator that the
original implementation of sci_mpxed_interrupt() was written with a
particular sub-type in mind ;-)

Applied, thanks.
