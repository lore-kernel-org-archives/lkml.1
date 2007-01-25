Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXAYCU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXAYCU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXAYCU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:20:27 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:36946 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbXAYCU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:20:26 -0500
Date: Thu, 25 Jan 2007 11:18:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: support preset lpj value as config option
Message-ID: <20070125021847.GA7609@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Bird <tim.bird@am.sony.com>,
	linux kernel <linux-kernel@vger.kernel.org>
References: <45B7F5E2.4070800@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B7F5E2.4070800@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 04:12:18PM -0800, Tim Bird wrote:
> This patch provides a config option for preset lpj, which means
> the value can be easily preserved, and conveyed between developers
> in a config file.
> 
This seems excessive, it's already possible to set the preset lpj on the
kernel command line, and virtually every one of the embedded
architectures supports setting the kernel command line as a config
option. Is there any reason why you can't simply set it there as a
default instead? It's all going to be .config resident in the end
anyways.
