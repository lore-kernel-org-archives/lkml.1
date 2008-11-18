Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYKRAmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYKRAmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKRAl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:41:59 -0500
Received: from kroah.org ([198.145.64.141]:51860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750952AbYKRAl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:41:58 -0500
Date: Mon, 17 Nov 2008 16:31:55 -0800
From: Greg KH <greg@kroah.com>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] samples: mark {static|__init|__exit} for {init|exit}
	functions
Message-ID: <20081118003155.GA16065@kroah.com>
References: <49201032.0c486e0a.0f62.684c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49201032.0c486e0a.0f62.684c@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 08:20:56PM +0800, Qinghuang Feng wrote:
> None of these (init|exit) functions is called from
> other functions which is outside the kernel module 
> mechanism or kernel itself, so mark them as 
> {static|__init|__exit}.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

