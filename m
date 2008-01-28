Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbYA1UyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbYA1UyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYA1UyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:54:10 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:43320 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYA1UyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:54:09 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Date: Mon, 28 Jan 2008 15:46:58 -0500
User-Agent: KMail/1.9.6
Cc: Doug Maxey <dwm@enoyolf.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, greg@kroah.com, darnok@68k.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com, arjan@infradead.org, michaelc@cs.wisc.edu,
       Andy Whitcroft <apw@shadowen.org>
References: <20080125220629.GA25325@andromeda.dapyr.net> <22101.1201547493@bebe.enoyolf.org> <479E2E89.7030704@zytor.com>
In-Reply-To: <479E2E89.7030704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281547.00865.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> iBFT is not platform-independent; it only makes sense on platforms with
> ACPI (and even then, just barely; ACPI is a poor fit for it and it was
> probably "integrated" with ACPI for political reasons.)

The spec just mentions that iBFT table has to be "compatible with an ACPI 
table format" and nothing else. In reality I've only tested this on x86_64 
and i386. We can limit it to be X86 || IA64 but I wouldn't make it dependent 
on ACPI - as this data does not necessarily have to be exported via ACPI.
