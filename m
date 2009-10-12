Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZJLWqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZJLWqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZJLWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:46:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758504AbZJLWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:46:11 -0400
Date: Mon, 12 Oct 2009 15:45:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: bcm5974: report ABS_MT events
Message-Id: <20091012154528.6830da60.akpm@linux-foundation.org>
In-Reply-To: <1255386223-4109-2-git-send-email-rydberg@euromail.se>
References: <1255386223-4109-1-git-send-email-rydberg@euromail.se>
	<1255386223-4109-2-git-send-email-rydberg@euromail.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 00:23:43 +0200
"Henrik Rydberg" <rydberg@euromail.se> wrote:

> This patch makes bcm5974 report raw multi-touch (MT) data in the form
> of ABS_MT events. The module parameter (nomt) may be used to turn off
> the effect of this patch.
> 

Why do we need a module parameter to disable the newly-added feature?

IMO, your first patch ("input: bcm5974: retract efi-broken
suspend_resume") is 2.6.32 material whereas this one is 2.6.33
material?

This assumes that the two patches can be safely separated in this
manner, which does appear to be the case.

