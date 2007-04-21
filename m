Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXDUJsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXDUJsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXDUJsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:48:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:53355 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbXDUJsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:48:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [RFC PATCH 1/3] x86: use defined names for all CPU feature flags
Date: Sat, 21 Apr 2007 11:47:39 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <4629438C.4070209@redhat.com> <46294444.1050608@redhat.com>
In-Reply-To: <46294444.1050608@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704211147.40058.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 00:52:52 Chuck Ebbert wrote:
>         /* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
>            3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
> -       clear_bit(0*32+31, &c->x86_capability);
> +       clear_bit(X86_FEATURE_PBE, &c->x86_capability);
>         


That doesn't match the comment.

-Andi
