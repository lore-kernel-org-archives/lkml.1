Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYFXXky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYFXXky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYFXXkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:40:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYFXXkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:40:46 -0400
Date: Tue, 24 Jun 2008 16:40:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nye Liu <nyet@mrv.com>
Cc: panto@intracom.gr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] CPM1: Don't send break on TX_STOP, don't interrupt
 RX/TX when adjusting termios parameters
Message-Id: <20080624164041.b5406d9f.akpm@linux-foundation.org>
In-Reply-To: <20080620194650.GA30019@mrv.com>
References: <20080620194650.GA30019@mrv.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 12:46:50 -0700
Nye Liu <nyet@mrv.com> wrote:

> From: Nye Liu <nyet@mrv.com>
> 
> Before setting STOP_TX, set _brkcr to 0 so the SMC does not send a break
> character. The driver appears to properly re-initialize _brkcr when the SMC is
> restarted.
> 
> Do not interrupt RX/TX when the termios is being adjusted; it results in
> corrupted characters appearing on the line.

Please send a Signed-off-by: for this change, as per
Documentation/SubmittingPatches, thanks.
