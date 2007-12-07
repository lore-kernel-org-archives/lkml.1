Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXLGXNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXLGXNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbXLGXM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:12:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbXLGXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:12:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=madzGc7JpzSax8NoxfdRN16AdoFI0hl7CK2IL7sFF1g2ImQEF00COeZ7cO/SlRP0S
	Z5MCr9NSSH948vuVW1GJA==
Date: Fri, 7 Dec 2007 15:11:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Nathan Lynch <ntl@pobox.com>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
In-Reply-To: <4759C89B.9000709@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.0.9999.0712071510370.27689@chino.kir.corp.google.com>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207221106.GH16824@localdomain> <4759C89B.9000709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Balbir Singh wrote:

> Yes, they all appear on node 0. We could have tweaks to distribute CPU's
> as well.
> 

You're going to want to distribute the cpu's based on how they match up 
physically with the actual platform that you're running on.  x86_64 does 
this already and it makes fake NUMA more useful because it matches the 
real-life case more often.
