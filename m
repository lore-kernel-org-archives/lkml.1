Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXJBIGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXJBIGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXJBIGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:06:20 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:47087 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbXJBIGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:06:16 -0400
Date: Tue, 2 Oct 2007 17:05:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 04/15](repost) Utility functions and securityfs interface for policy manipulation.
Message-ID: <20071002080544.GA14313@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	chrisw@sous-sol.org
References: <4701F285.5000206@nttdata.co.jp> <4701F3E4.7030901@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4701F3E4.7030901@nttdata.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 04:31:48PM +0900, Kentaro Takeda wrote:
> Common functions for TOMOYO Linux.
> 
> TOMOYO Linux uses /sys/kernel/security/tomoyo interface for configuration.
> 
This seems like a bit of an abuse of sysfs. Isn't this precisely what
configfs is for?
