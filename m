Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbYGBHjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbYGBHjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761696AbYGBHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:39:00 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:17341 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759733AbYGBHi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:38:59 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] remove dummy asm/kvm.h files
Date: Wed, 2 Jul 2008 09:38:50 +0200
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@qumranet.com>, linux-arch@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
References: <20080701162716.GB32598@cs181140183.pp.htv.fi>
In-Reply-To: <20080701162716.GB32598@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020938.50194.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 1. Juli 2008 schrieb Adrian Bunk:
> This patch removes the dummy asm/kvm.h files on architectures not (yet) 
> supporting KVM and uses the same conditional headers installation as
> already used for a.out.h .
> 
> Also removed are superfluous install rules in the s390 and x86 Kbuild 
> files (they are already in Kbuild.asm).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Seems to work on s390, ppc and arm as expected.
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
