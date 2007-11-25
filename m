Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXKYSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXKYSp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 13:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXKYSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 13:45:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:29470 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXKYSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 13:45:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tPQAFqOF6TN/wwqfW4+9//NAGJskXSHXBThcwcc7bm3V8QcZtPRFROpFbuDZ5aKvEMnlo2ON6ODXCa690PV8Z537isdn14ARYwA7U1PXaSce2nSiMeZsN6h0vi05hzp2Amf+yzHySgVxm2sn3wEvNKf9AZ+n0kbBk8wgKWy3Jfg=
Message-ID: <de8d50360711251045l4566f894m92fbb32d00fa362@mail.gmail.com>
Date: Sun, 25 Nov 2007 10:45:17 -0800
From: "Andrew Pinski" <pinskia@gmail.com>
To: Luca <luca.b633@gmail.com>
Subject: Re: [RFC] [PATCH] 32-bit pointers in x86-64
Cc: gcc@gcc.gnu.org, binutils@sourceware.org, libc-alpha@sourceware.org,
       ubuntu-devel@lists.ubuntu.com, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1ba5638c0711250829o416e3ccasba572d3c205ea7f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba5638c0711250829o416e3ccasba572d3c205ea7f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/07, Luca <luca.b633@gmail.com> wrote:
> 7.1. Add __attribute__((pointer_size(XXX))) and #pragma pointer_size
> to allow 64-bit pointers in 32-bit mode and viceversa

This is already there, try using __attribute__((mode(DI) )).

-- Pinski
