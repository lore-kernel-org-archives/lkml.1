Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZG2Nqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZG2Nqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZG2Nqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:46:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:42830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZG2Nq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:46:29 -0400
Message-ID: <4A7052B4.8030102@suse.de>
Date: Wed, 29 Jul 2009 15:46:28 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] kvm/svm: complete interrupts after handling nested
 exits
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-7-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-7-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> The interrupt completion code must run after nested exits are handled
> because not injected interrupts or exceptions may be handled by the l1
> guest first.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>   

If you say so, I believe you :-).

Acked-by: Alexander Graf <agraf@suse.de>

