Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbYA0GBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbYA0GBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYA0GBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:01:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbYA0GBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:01:04 -0500
Date: Sat, 26 Jan 2008 22:00:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Teigland <teigland@redhat.com>
Cc: linux-kernel@vger.kernel.org, fabbione@ubuntu.com
Subject: Re: [PATCH 07/19] dlm: swap bytes for rcom lock reply
Message-Id: <20080126220029.98dc3826.akpm@linux-foundation.org>
In-Reply-To: <1201193442-8260-8-git-send-email-teigland@redhat.com>
References: <1201193442-8260-8-git-send-email-teigland@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 10:50:30 -0600 David Teigland <teigland@redhat.com> wrote:
>  void dlm_rcom_in(struct dlm_rcom *rc)
>  {
>  	struct dlm_header *hd = (struct dlm_header *) rc;

aww, c'mon guys, this is nonsense.

	struct dlm_header *hd = &rc->rc_header;

there seems to be rather a lot of this unnecessary casting going on in dlm. 
Please do a hunt-and-exterminate.

