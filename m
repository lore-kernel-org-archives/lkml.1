Return-Path: <linux-kernel-owner+w=401wt.eu-S1761865AbXISQSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865AbXISQSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbXISQSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:18:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:34652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674AbXISQSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:18:03 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrey Mirkin <major@openvz.org>
Subject: Re: [PATCH] return correct error code from child_rip in x86_64 entry.S
Date: Wed, 19 Sep 2007 18:17:59 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200709191826.27764.major@openvz.org>
In-Reply-To: <200709191826.27764.major@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191817.59641.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 16:26:25 Andrey Mirkin wrote:
> From: Andrey Mirkin <major@openvz.org>
> 
> Right now register edi is just cleared before calling do_exit.
> That is wrong because correct return value will be ignored.
> Value from rax should be copied to rdi instead of clearing edi.

Applied thanks

-Andi
