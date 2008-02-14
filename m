Return-Path: <linux-kernel-owner+w=401wt.eu-S934693AbYBNBDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbYBNBDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbYBNBCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:02:52 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:5506 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbYBNBCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Xh4bMr/ABh2JagK5ri1BtHLUQQOwCX+JCL7gkfg7AXp7vU6CClXJ4GglQ3Qk6aafWaM3xo19SCZKRbgs/yc6FA/jpfVNXwAgD+a8/MeW/+EFAcVqSZHejyto+TJc5pWJ4DBTOIl+RNU2ebHTX57ph9fNY0fEcEwVWDPFjoHNpIM=
Message-ID: <e9c3a7c20802131702u3b738b2dy28054c221c105022@mail.gmail.com>
Date: Wed, 13 Feb 2008 18:02:48 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>
Subject: Re: [PATCH][I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec
Cc: shannon.nelson@intel.com, "Chris Leech" <christopher.leech@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47B35B88.5070300@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B35B88.5070300@inria.fr>
X-Google-Sender-Auth: a29f074fbc66f345
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 2:05 PM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> [I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec
>
> No need to compute copy twice in the frags loop in
> dma_skb_copy_datagram_iovec().
>
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

Thanks, I'll push this along.

--
Dan
