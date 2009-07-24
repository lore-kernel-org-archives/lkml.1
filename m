Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZGXSXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZGXSXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZGXSXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:23:15 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:57806 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798AbZGXSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:23:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [PATCH] ia64: minor Makefile simplification through use =?iso-8859-1?q?of=09cc-ifversion?=
Date: Fri, 24 Jul 2009 20:23:11 +0200
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-ia64@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200907232056.51064.elendil@planet.nl> <20090723212809.GB9488@merkur.ravnborg.org> <87ws5yoo44.wl%peterc@nicta.com.au>
In-Reply-To: <87ws5yoo44.wl%peterc@nicta.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907242023.12478.elendil@planet.nl>
X-OriginalArrivalTime: 24 Jul 2009 18:23:13.0051 (UTC) FILETIME=[CE0E46B0:01CA0C8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009, Peter Chubb wrote:
> >>>>> "Sam" == Sam Ravnborg <sam@ravnborg.org> writes:
> Sam> The above change is correct.  But I really wonder if the original
> Sam> code was correct?  Do we really only want to use the -mtune
> Sam> options for this specific gcc version?  If this is indeed the
> Sam> case this deserves a comment explaning this.
>
> I suspect it should be all compilers after this one.  -mtune=mckinley
> didn't work very well in the early gcc 3 compilers and didn't exist in
> version 2.

How would you like to handle that? As it is essentially a separate issue, 
my suggestion would be: apply my patch as is and then (if needed) commit 
a separate patch to fix the incorrect comparisons on top.

Cheers,
FJP
