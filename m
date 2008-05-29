Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYE2Stg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYE2Stg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbYE2StY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:49:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbYE2StX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:49:23 -0400
Message-ID: <483EFA6C.6030804@zytor.com>
Date: Thu, 29 May 2008 11:48:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] Use structs instead of hardcoded offsets in x86
 boot decompressor.
References: <1212082032-6167-1-git-send-email-krh@redhat.com>
In-Reply-To: <1212082032-6167-1-git-send-email-krh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> 
> Updated this one to be less intrusive; we just re-#define RM_SCREEN_INFO to
> access the boot_params struct instead of using the hard-coded offset.
> 

Any reason to leave it in as a macro at all, instead of just 
s/RM_SCREEN_INFO/real_mode->screen_info/g?

We have already gotten rid of most of these macros in the primary kernel.

	-hpa

P.S. Sorry for not giving you feedback sooner.
