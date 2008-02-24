Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYBXDHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYBXDHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBXDG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:06:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYBXDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:06:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=X7XVK3/PDqCR6KCeamUaPne7s4hVtX9oH7BepkHo/ESg8n6M4XIqzrh9nBFb5ei92
	2l2qmGbGj0t0LdXJwvulg==
Message-ID: <6599ad830802231906k3ae0e30fvcda453d7afc4d907@mail.gmail.com>
Date: Sat, 23 Feb 2008 19:06:45 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
Cc: "Andrew Morton" <akpm@linux-foundation.org>, xemul@openvz.org,
       balbir@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <47C0DAD8.8050401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221203518.544461000@menage.corp.google.com>
	 <20080221205525.349180000@menage.corp.google.com>
	 <47BE4FB5.5040902@linux.vnet.ibm.com>
	 <6599ad830802230633i483c8dd1q5b541be1a92a5795@mail.gmail.com>
	 <20080223105933.e6884808.akpm@linux-foundation.org>
	 <47C0DAD8.8050401@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 6:47 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  >> res_counter_read_u64() I'd also want to rename all the other
>  >> *read_uint functions/fields to *read_u64 too. Can I do that in a
>  >> separate patch?
>  >>
>  >
>  > Sounds sensible to me.
>  >
>
>  Sure, fair enough.
>

Actually, since multiple people were asking for this change I did the
search/replace and sent it out already (as a precursor of the other
patches in the series that I sent today).

Paul
