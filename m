Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYFMNux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYFMNux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYFMNun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:50:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbYFMNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:50:42 -0400
Subject: Re: [PATCH] firewire: fw-ohci: write selfIDBufferPtr before
	LinkControl.rcvSelfID
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.999def4a37c1ecd9@s5r6.in-berlin.de>
References: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de>
	 <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de>
	 <tkrat.999def4a37c1ecd9@s5r6.in-berlin.de>
Content-Type: text/plain; charset=utf8
Date: Fri, 13 Jun 2008 09:50:14 -0400
Message-Id: <1213365014.15164.38.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 20:50 +0200, Stefan Richter wrote:
> OHCI 1.1 clause 5.10 requires that selfIDBufferPtr is valid when a 1 is
> written into LinkControl.rcvSelfID.
> 
> This driver bug has so far not been known to cause harm because most
> chips obviously accept a later selfIDBufferPtr write.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Yeah, good point.  I think it also caused no harm because we set it up
before enabling the link.  But your change definitely looks good.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>


