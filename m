Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZLVVvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZLVVvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZLVVvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:51:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbZLVVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:51:53 -0500
Date: Tue, 22 Dec 2009 13:50:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Smith, GeoffX" <geoffx.smith@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, stable@kernel.org
Subject: Re: [PATCH] prctl: return timerslack through pointer
Message-Id: <20091222135041.b24abeff.akpm@linux-foundation.org>
In-Reply-To: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE12F3@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE12F3@orsmsx510.amr.corp.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 16:17:15 -0800
"Smith, GeoffX" <geoffx.smith@intel.com> wrote:

> This patch fixes the semantics of prctl() option PR_GET_TIMERSLACK
> to pass the return value through *arg2.
> 
> With this change, the option now follows the same conventions as the
> other "get" options added since 2.6.0, and also brings it into
> conformance with the advice in chapter 16 of Documentation/CodingStyle.
> 
> In addition, it effectively doubles the range of time slack to 4.29
> seconds (on a 32-bit architecture).
> 
> The timer slack feature was only added in Sep 2009 (new in 2.6.32.1), 
> so there are not any production applications to break.  I have also 
> repaired some unmatched signed/unsigned mismatches in timer slack
> calculations.
> 

If we're going to do this then we should backport the patch into
2.6.32.x as well.  And I agree that there is time to make this change.

> diff --git a/kernel/sys.c b/kernel/sys.c
> index 20ccfb5..e01da12 100644

You omitted the Signed-off-by: line (described in
Documentation/SubmittingPatches).  Please send one.

