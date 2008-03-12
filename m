Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYCLOGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYCLOGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYCLOGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:06:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYCLOGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:06:38 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
Date: Wed, 12 Mar 2008 10:06:20 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.cd36eb4efecd7f14@s5r6.in-berlin.de> <tkrat.6437b6cf5ad12894@s5r6.in-berlin.de>
In-Reply-To: <tkrat.6437b6cf5ad12894@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121006.20249.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 05:32:52 pm Stefan Richter wrote:
> Fix I/O errors due to SYM13FW500's inability to handle larger request
> sizes.  Reported by Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> for
> firewire-sbp2 in https://bugzilla.redhat.com/show_bug.cgi?id=436879
>
> This fix is necessary because sbp2's default request size limit has been
> lifted since 2.6.25-rc1.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
