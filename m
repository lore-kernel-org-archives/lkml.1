Return-Path: <linux-kernel-owner+w=401wt.eu-S937008AbXFHBeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937008AbXFHBeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934164AbXFHBd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:33:56 -0400
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:57262 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933212AbXFHBd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:33:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Thu, 7 Jun 2007 18:33:45 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <20070607172050.ead923b4.akpm@linux-foundation.org>
In-Reply-To: <20070607172050.ead923b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071833.45929.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 7, 2007 5:20:50 Andrew Morton wrote:
> > -unsigned int *usage_table;
> > +unsigned int usage_table[NUM_VAR_RANGES];
> >  static DEFINE_MUTEX(mtrr_mutex);
>
> didn't it feel all dirty when you had to do that?

Hey, this was already there... I didn't want to rewrite the whole thing at 
once. :)  Patch looks fine though.

Thanks,
Jesse
