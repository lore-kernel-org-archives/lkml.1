Return-Path: <linux-kernel-owner+w=401wt.eu-S933370AbXBACwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbXBACwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933377AbXBACwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:52:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:16339 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370AbXBACwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TPy51bVs6OV909o7HARiKIMid39LC/gsiusLgpipDV1DKnUk8SDuOWA/Qt8+H1G2aJ83eg1B5waLf72Xjd21QJ91mm3uZO19dwDbmV2WensG7pCdmMdAzEzq9HwgzwHzlc1NdK0Vf+tumpqSmZlWDiIGbCIk/qN+N6HaVsIr4QA=
Message-ID: <b6a2187b0701311852i610ffc13wcc37d455ed734c86@mail.gmail.com>
Date: Thu, 1 Feb 2007 10:52:40 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] KVM: Fix lockup on 32-bit intel hosts with nx disabled in the bios
Cc: kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070131150017.020B9A0014@il.qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070131150017.020B9A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Avi Kivity <avi@qumranet.com> wrote:
> Intel hosts, without long mode, and with nx support disabled in the bios
> have an efer that is readable but not writable.  This causes a lockup on
> switch to guest mode (even though it should exit with reason 34 according to
> the documentation).

Avi, thank you for the patch. I can confirm that this patch works on
my IBM X60s notebook. Without it, the whole PC locks up upon starting
qemu.

Thanks,
Jeff.
