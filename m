Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYE2T6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYE2T6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYE2T6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:58:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYE2T6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:58:36 -0400
Subject: Re: [PATCH 1/2 v3] Use structs instead of hardcoded offsets in x86
	boot decompressor.
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <483EFA6C.6030804@zytor.com>
References: <1212082032-6167-1-git-send-email-krh@redhat.com>
	 <483EFA6C.6030804@zytor.com>
Content-Type: text/plain; charset=utf8
Date: Thu, 29 May 2008 15:58:31 -0400
Message-Id: <1212091111.6189.12.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 11:48 -0700, H. Peter Anvin wrote:
> Kristian Høgsberg wrote:
> > 
> > Updated this one to be less intrusive; we just re-#define RM_SCREEN_INFO to
> > access the boot_params struct instead of using the hard-coded offset.
> > 
> 
> Any reason to leave it in as a macro at all, instead of just 
> s/RM_SCREEN_INFO/real_mode->screen_info/g?

Only to keep the patch smaller.  Accessing the struct directly is
definitely nicer, I'll do the sed job when I resubmit with the other
patch.

cheers,
Kristian

