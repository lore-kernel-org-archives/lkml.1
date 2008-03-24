Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYCXU2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYCXU2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYCXU2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:28:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYCXU2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:28:14 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: unnecessary BM delay after generation rollover
Date: Mon, 24 Mar 2008 16:11:35 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.7cb6088b953ca5bd@s5r6.in-berlin.de>
In-Reply-To: <tkrat.7cb6088b953ca5bd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803241611.35825.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2008 03:56:40 pm Stefan Richter wrote:
> Noticed by Jarod Wilson:  The bus manager work was unnecessarily delayed
> each time the bus generation counter rolled over.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Much nicer than the crappy patch I had in mind (just adding another && 
0xff). :)

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
