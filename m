Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYCTOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYCTOft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYCTOff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:35:35 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35443 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbYCTOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:35:34 -0400
Subject: Re: [RFC][PATCH] mark /proc/sys/dev/scsi/logging_level to be
	removed
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Denis Cheng <crquan@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1206018190-5888-1-git-send-email-crquan@gmail.com>
References: <1206018190-5888-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 09:35:30 -0500
Message-Id: <1206023730.3038.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 21:03 +0800, Denis Cheng wrote:
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
> Since scsi_logging_level module_param can be read/written while system
> running, the demand for /proc/sys/dev/scsi/logging_level has been no longer
> mandotory.
> 
> But someone might have already set this value in /etc/sysctl.conf, so
> mark it to be removed in one year (until March 2009).
> 
> One year might be not enough or too long, this period should also be discussed.

I don't think there's really much point to doing this.  We're already tied to the SYS_SYSCTL deprecation Eric Biderman is hoping to do for this; it's much better if the whole lot goes at once rather than piecemeal (particularly if sysctl stays around longer than anticipated).

James


