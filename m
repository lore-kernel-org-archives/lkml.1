Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbYLMSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbYLMSXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLMSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:23:08 -0500
Received: from kroah.org ([198.145.64.141]:38098 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750834AbYLMSXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:23:08 -0500
Date: Sat, 13 Dec 2008 10:16:53 -0800
From: Greg KH <greg@kroah.com>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: don't pass cls->name as format string in
	sysdev_class_register()
Message-ID: <20081213181653.GD6953@kroah.com>
References: <1229164440-4631-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229164440-4631-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 06:34:00PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> If cls->name contains substring which can be interpreted as
> format,maybe it causes oops, so fix it.

Why not fix the code that would set cls->name to such a wrong field?  I
don't see any in-kernel code that does this, do you?

thanks,

greg k-h
