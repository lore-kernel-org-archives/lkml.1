Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXF2FKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXF2FKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbXF2FKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:10:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:15129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXF2FJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tedTx4d+Vtjz7diFivK+FhRgKBthmoWTn2rzvlXuppcP3fPDkZficOQY00xhiJXm9GkQ0OeSEUNuZ91XAkRbE1mP6ws8hq/AvFMzIs5vyc7ZcUjLzzh9ml3AwN7NCw/a0isMvnhhzPSmi9Ips/B20ZZpYx0oPfH/nokm6Q+LQdw=
Message-ID: <a36005b50706282209p52cd3251l7ce2d90ca700cd99@mail.gmail.com>
Date: Thu, 28 Jun 2007 22:09:58 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andy Isaacson" <adi@hexapodia.org>
In-Reply-To: <468476AA.6090905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
	 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
	 <468476AA.6090905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Rik van Riel <riel@redhat.com> wrote:
> That wants MAP_PRIVATE so that the kernel can also decide to not
> swap these pages out to an unencrypted swap area.

That's not what MAP_PRIVATE means.  MAP_PRIVATE is the opposite of
MAP_SHARED.  It's meaningless for anonymous memory (which is what
ssh-agent etc would use) and for file-backed data it definitely allows
swapping unless you use mlock().
