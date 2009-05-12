Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZELOZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZELOZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZELOZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:25:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:30105 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZELOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kh+T9J3QA/E50z7ueaymO/3FCacXcheHtz60c2dOV6/Adczo1NG+c6qXVJF9pp5ibi
         l1Ppn8trgUvtqZ9o2QhIDp2qJlPCbqbA6Oe6634UVqMr8cxwfOQpqOfUf2/hP5qegvv/
         3jmYHooXy6dvgGbBrTvZRjerOn7V8QbfUW3DU=
MIME-Version: 1.0
In-Reply-To: <877i0xib7d.fsf@basil.nowhere.org>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	 <877i0xib7d.fsf@basil.nowhere.org>
Date: Tue, 12 May 2009 07:20:14 -0700
Message-ID: <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
Subject: Re: Specific support for Intel Atom architecture
From: Ulrich Drepper <drepper@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 12:22 AM, Andi Kleen <andi@firstfloor.org> wrote:
> This should be obsolete anyways, you can just uses CORE2. They have compatible ISAs.

Only correct if you don't plan to use the movbe instruction.  The
kernel would be the one place where I can imagine this to make sense.
