Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYIINrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYIINrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYIINrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:47:06 -0400
Received: from il.qumranet.com ([212.179.150.194]:40904 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYIINrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:47:05 -0400
Message-ID: <48C67E57.1050309@qumranet.com>
Date: Tue, 09 Sep 2008 16:47:03 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sheng Yang <sheng.yang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Move VMX MSRs to msr-index.h
References: <12208705553277-git-send-email-sheng.yang@intel.com> <1220870555659-git-send-email-sheng.yang@intel.com>
In-Reply-To: <1220870555659-git-send-email-sheng.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang wrote:
> They are hardware specific MSRs, and we would use them in virtualization
> feature detection later.
>
>   


> -
> -#define MSR_IA32_FEATURE_CONTROL                0x3a
>  #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
>  #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x

Might as well move these two bitmask definitions.


-- 
error compiling committee.c: too many arguments to function

