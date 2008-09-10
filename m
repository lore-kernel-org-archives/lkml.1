Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYIJKlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYIJKlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYIJKkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:40:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:31977 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYIJKky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="44366947"
From: "Yang, Sheng" <sheng.yang@intel.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 1/2] x86: Move VMX MSRs to msr-index.h
Date: Wed, 10 Sep 2008 18:44:15 +0800
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <12208705553277-git-send-email-sheng.yang@intel.com> <1220870555659-git-send-email-sheng.yang@intel.com> <48C67E57.1050309@qumranet.com>
In-Reply-To: <48C67E57.1050309@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101844.16091.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 21:47:03 Avi Kivity wrote:
> Sheng Yang wrote:
> > They are hardware specific MSRs, and we would use them in virtualization
> > feature detection later.
> >
> >
> >
> >
> > -
> > -#define MSR_IA32_FEATURE_CONTROL                0x3a
> >  #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
> >  #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x
>
> Might as well move these two bitmask definitions.

Um... I think it's better to leave them here, for the MSR_IA32_FEATURE_CONTROL 
is a MSR which can be put into msr-index.h, but the others are only bits of 
MSR...

-- 
regards
Yang, Sheng
