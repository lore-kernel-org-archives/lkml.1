Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYELPVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYELPVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYELPV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:21:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYELPV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:21:29 -0400
Date: Mon, 12 May 2008 10:20:55 -0500
From: David Teigland <teigland@redhat.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] dlm: tcp_connect_to_sock should check for -EINVAL, not EINVAL
Message-ID: <20080512152055.GA31873@redhat.com>
References: <20080511200125.GI19058@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511200125.GI19058@joi>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:01:29PM +0200, Marcin Slusarz wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Christine Caulfield <ccaulfie@redhat.com>
> Cc: David Teigland <teigland@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
> it's probably a typo, but I'm not sure
> please check if it's the right fix (maybe this condition should be dropped?)
> (compile tested only)

Thanks, I've added this to dlm.git.

Dave

