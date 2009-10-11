Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZJKKCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZJKKCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZJKKCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:02:53 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:49782 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbZJKKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:02:53 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Sun, 11 Oct 2009 11:56:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>
References: <200910100322.36857.thomas.schlichter@web.de> <200910101031.15620.thomas.schlichter@web.de> <4AD0ABFF.1020209@linux.intel.com>
In-Reply-To: <4AD0ABFF.1020209@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910111156.54951.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX19QFd7ibY59/VPghdp5SzBHEORokV3zSuhx+srU
	lPQpG1S2B2a193DIPHyHKzWQslcou6Le4IYF1Kw3H0cy1RRRH9
	zNCAdm9df8gIhky+1LPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Schlichter wrote:
> > So, convincing Ubuntu to enable PAT would be a workaround, but I think
> > the problem would still exist and should be fixed.
> 
> I think it's time to get rid of CONFIG_PAT at all.. and just have it be
>  there. Making 10+ year old CPU features that are essential functionality a
>  config option... ... not a good idea to be honest.

I do completely agree with you in this point.

But should the current behavior of not using MTRR for write combining when PAT 
is disabled (for whatever reason) stay? I think it is more consistent to do 
whatever is necessary to enable write combining when we are asked to.

Kind regards,
  Thomas
