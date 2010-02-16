Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0BPLj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:39:59 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:33377 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0BPLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:39:58 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: bskeggs@redhat.com
Subject: Re: [git pull] drm
Date: Tue, 16 Feb 2010 12:39:54 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-self-00027-gfed1661; KDE/4.3.4; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Maarten Maathuis <madman2003@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
References: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie> <201002152355.03161.borntraeger@de.ibm.com> <1266283177.24236.1.camel@nisroch>
In-Reply-To: <1266283177.24236.1.camel@nisroch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161239.54910.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 16 Februar 2010 02:19:37 schrieb Ben Skeggs:
> Ah, it appears the vbios delay opcodes got changed to use sleeps rather
> than delays at some point without me noticing.  Sent a patch to Dave
> changing the code to use a mutex instead for now.

Ok, I cherry-picked d9184fa97b6f48d399636e5e2669bc8419f9369e from for-airlied
The fix seems to work.

If you like you can add

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>

Christian
