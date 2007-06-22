Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbXFVJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbXFVJa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXFVJav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:30:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:56149 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbXFVJau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:30:50 -0400
Message-ID: <467B96C8.1050500@qumranet.com>
Date: Fri, 22 Jun 2007 12:30:48 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SVM: reliably detect if SVM was disabled by BIOS
References: <20070621175122.GE25896@amd.com>
In-Reply-To: <20070621175122.GE25896@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 22 Jun 2007 12:30:48 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
>
> This patch adds an implementation to the svm is_disabled function to
> detect reliably if the BIOS disabled the SVM feature in the CPU. This
> fixes the issues with kernel panics when loading the kvm-amd module on
> machines where SVM is available but disabled.
>
>   

Applied; thanks.

Is this msr documented anywhere?  I assume it is implemented on all
processors with svm?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

