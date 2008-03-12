Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYCLTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYCLTmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYCLTmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:42:11 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:60454 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYCLTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:42:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:subject:message-id:mime-version:content-type:con
	tent-disposition:content-transfer-encoding:in-reply-to:user-age
	nt;
	b=neiEBmwfWG7uE4IV9UCeJ0o0l8QU8xljx4es71LoBfHs6zrYvQOxwwtdVvGL6
	KapHZYFdRo9w1UR6qe6zawe2Q==
Date: Wed, 12 Mar 2008 20:42:08 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org,
       Linas =?utf-8?B?xb12aXJibGlz?= <0x0007@gmail.com>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Message-ID: <20080312194208.GE25169@xi.wantstofly.org>
References: <200803120141.51844.rjw@sisk.pl> <20080312194035.GA23482@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080312194035.GA23482@dose.home.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 08:40:35PM +0100, Tino Keitel wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
> > Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> > Submitter	: Linas Žvirblis <0x0007@gmail.com>
> > Date		: 2008-02-13 22:38 (29 days old)
> > References	: http://lkml.org/lkml/2008/2/13/566
> 
> could this be connected to http://lkml.org/lkml/2008/3/12/77?

I do get oops output, i.e. I don't see a hard lockup.

[ FWIW, the commit linked to in that email
  (e82cc1288fa57857c6af8c57f3d07096d4bcd9d9) seems to fix my issue. ]
